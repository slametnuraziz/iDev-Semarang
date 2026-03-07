exports.isGuru = (req, res, next) => {
    if (req.user.role !== 'guru') {
        return res.status(403).json({
            success: false,
            message: 'Akses khusus guru'
        });
    }
    next();
};

exports.isSiswa = (req, res, next) => {
    if (req.user.role !== 'siswa') {
        return res.status(403).json({
            success: false,
            message: 'Akses khusus siswa'
        });
    }
    next();
};
