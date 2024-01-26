const jwt = require('jsonwebtoken');
const config = require('config');
const bcrypt = require('bcrypt');
const _ = require('lodash');
const User = require("../../models/user-model");
const validator = require('../../validators/admin-validator');



exports.addingAdmin = async (req, res) => {
    if (req.user.role !== 'admin')
        return res.status(403).json({
            message: 'Access Denied, Only Admins Can Access This'
        });

    const { error } = validator.validateAddingAdmin(req.body);

    if (error)
        return res.status(401).json({
            message: error.details[0].message
        });

    try {

        let user = await User.findOne({ email: req.body.email });

        if (user)
            return res.status(400).json({
                message: 'This Email Is Already Registered',
            });

        user = await User.findOne({ userName: req.body.userName });

        if (user)
            return res.status(400).json({
                message: "This User Name Is Already Used",
            });

        const salt = await bcrypt.genSalt(12);

        req.body.password = await bcrypt.hash(req.body.password, salt);

        user = await User.create(_.pick(req.body, [
            'name',
            'email',
            'password',
            'userName'
        ]));

        if (!user)
            res.status(400).json({
                status: 'Failed',
                message: 'Failed To Add The Admin'
            });

        res.status(201).json({
            status: 'Succeeded',
            message: 'Admin Added Successfully'
        });

    } catch (err) {
        res.status(500).json({
            message: err.message
        });
    }
};


exports.loginAdmin = async (req, res) => {

    const { error } = validator.validateAdminLogIn(req.body);

    if (error)
        return res.status(401).json({
            message: error.details[0].message
        });

    try {

        let user = await User.findOne({ email: req.body.email });

        if (!user || user.role !== 'admin')
            return res.status(400).json({
                message: "Invalid email or password"
            });

        let validPassword = await bcrypt.compare(req.body.password, user.password);

        if (!validPassword)
            return res.status(400).json({
                message: "Invalid email or password"
            });

        const token = jwt.sign({
            _id: user._id,
            email: user.email,
            userName: user.userName,
            role: user.role
        }, config.get('jwtPrivateKey'));

        res.status(200).json({
            token: token,
            _id: user._id
        });

    } catch (err) {
        res.status(500).json({
            message: err.message
        });
    }
};