const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { Sequelize, DataTypes } = require('sequelize');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');

// --- KONFIGURASI ---
const app = express();
const PORT = 8000; // Sesuai dengan api_constants.dart kamu
const SECRET_KEY = 'rahasia_biji_kopi_super_aman'; // Ganti dengan key yang lebih rumit di production

app.use(cors());
app.use(bodyParser.json());

// --- DATABASE SETUP (SQLite) ---
const sequelize = new Sequelize({
    dialect: 'sqlite',
    storage: './database.sqlite', // File database akan otomatis dibuat di folder ini
    logging: false
});

// --- MODELS ---

// 1. Model User
const User = sequelize.define('User', {
    name: { type: DataTypes.STRING, allowNull: false },
    email: { type: DataTypes.STRING, allowNull: false, unique: true },
    password: { type: DataTypes.STRING, allowNull: false },
});

// 2. Model Product
const Product = sequelize.define('Product', {
    title: { type: DataTypes.STRING, allowNull: false },
    subtitle: { type: DataTypes.STRING },
    image: { type: DataTypes.STRING, defaultValue: 'assets/images/product1.jpg' }, // Default image
    price: { type: DataTypes.FLOAT, allowNull: false },
    category: { type: DataTypes.STRING, allowNull: false },
});

// Relasi One-to-Many: Satu User bisa punya banyak Produk (misal: Admin menginput produk)
User.hasMany(Product, { foreignKey: 'userId' });
Product.belongsTo(User, { foreignKey: 'userId' });

// --- MIDDLEWARE (Proteksi Token JWT) ---
const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1]; // Format: Bearer TOKEN

    if (!token) return res.status(401).json({ message: 'Akses ditolak. Token tidak ditemukan.' });

    jwt.verify(token, SECRET_KEY, (err, user) => {
        if (err) return res.status(403).json({ message: 'Token tidak valid.' });
        req.user = user;
        next();
    });
};

// --- ROUTES ---

// 1. Register
app.post('/api/register', async (req, res) => {
    try {
        const { name, email, password } = req.body;
        const hashedPassword = await bcrypt.hash(password, 10);
        
        const newUser = await User.create({ name, email, password: hashedPassword });
        
        res.status(201).json({ message: 'User berhasil didaftarkan', user: { id: newUser.id, email: newUser.email } });
    } catch (error) {
        res.status(400).json({ message: 'Gagal register. Email mungkin sudah dipakai.', error: error.message });
    }
});

// 2. Login
app.post('/api/login', async (req, res) => {
    try {
        const { email, password } = req.body;
        const user = await User.findOne({ where: { email } });

        if (!user) return res.status(404).json({ message: 'User tidak ditemukan' });

        const validPassword = await bcrypt.compare(password, user.password);
        if (!validPassword) return res.status(400).json({ message: 'Password salah' });

        // Buat Token
        const token = jwt.sign({ id: user.id, email: user.email }, SECRET_KEY, { expiresIn: '24h' });

        // Response sesuai format yang diharapkan login_page.dart kamu (access_token)
        res.json({ 
            message: 'Login berhasil', 
            access_token: token,
            user: { id: user.id, name: user.name, email: user.email }
        });
    } catch (error) {
        res.status(500).json({ message: 'Terjadi kesalahan server' });
    }
});

// 3. Get User Profile (Protected)
app.get('/api/user', authenticateToken, async (req, res) => {
    const user = await User.findByPk(req.user.id, { attributes: { exclude: ['password'] } });
    res.json(user);
});

// --- CRUD PRODUCTS ---

// Get All Products (Public - bisa diakses tanpa login, atau pakai middleware jika ingin private)
app.get('/api/products', async (req, res) => {
    try {
        const products = await Product.findAll({ include: User }); // Include user info
        res.json(products);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Add Product (Protected)
app.post('/api/products', authenticateToken, async (req, res) => {
    try {
        // userId diambil dari token (req.user.id)
        const { title, subtitle, price, category, image } = req.body;
        const newProduct = await Product.create({
            title, subtitle, price, category, image,
            userId: req.user.id 
        });
        res.status(201).json(newProduct);
    } catch (error) {
        res.status(400).json({ message: 'Gagal menambah produk', error: error.message });
    }
});

// Update Product (Protected)
app.put('/api/products/:id', authenticateToken, async (req, res) => {
    try {
        const product = await Product.findByPk(req.params.id);
        if (!product) return res.status(404).json({ message: 'Produk tidak ditemukan' });

        // Cek kepemilikan (Opsional: hanya pemilik yang bisa edit)
        if (product.userId !== req.user.id) return res.status(403).json({ message: 'Anda tidak memiliki izin mengedit produk ini' });

        await product.update(req.body);
        res.json({ message: 'Produk berhasil diupdate', product });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// Delete Product (Protected)
app.delete('/api/products/:id', authenticateToken, async (req, res) => {
    try {
        const product = await Product.findByPk(req.params.id);
        if (!product) return res.status(404).json({ message: 'Produk tidak ditemukan' });

        if (product.userId !== req.user.id) return res.status(403).json({ message: 'Anda tidak memiliki izin menghapus produk ini' });

        await product.destroy();
        res.json({ message: 'Produk berhasil dihapus' });
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
});

// --- JALANKAN SERVER ---
// force: false artinya jangan hapus data lama saat restart. Ubah ke true jika ingin reset DB.
sequelize.sync({ force: false }).then(() => {
    console.log('Database SQLite terkoneksi & sinkron.');
    app.listen(PORT, () => {
        console.log(`Server berjalan di http://localhost:${PORT}`);
    });
});