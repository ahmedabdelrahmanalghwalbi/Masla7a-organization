const Fuse = require('fuse.js');
const Complaint = require('../../models/complaint');
const { cleanObj } = require('../../utils/filterHelpers');


const customerOptions = {
    minMatchCharLength: 1,
    threshold: 0.2,
    keys: [
        'user.name'
    ]
};

const serviceProviderOptions = {
    minMatchCharLength: 1,
    threshold: 0.2,
    keys: [
        'serviceProvider.name'
    ]
};



exports.getComplaints = async (req, res) => {
    if (req.user.role !== 'admin')
        return res.status(403).json({
            message: 'Access Denied, Only Admins Can Access This'
        });


    try {
        let queryData = {};

        if (req.query.date_from && req.query.date_to) {
            if (new Date(req.query.date_from) >= new Date(req.query.date_to))
                return res.status(400).json({
                    message: 'The Start Date is Greater Than The End Date.'
                })
        }

        const dateInterval = {
            $gte: !req.query.date_from ?
                undefined : new Date(req.query.date_from),
            $lte: !req.query.date_to ?
                undefined : new Date(req.query.date_to)
        };

        cleanObj(dateInterval);


        if (Object.keys(dateInterval).length > 0) {
            queryData.createdAt = dateInterval
        }

        let complaints = await Complaint
            .find(queryData)
            .populate('serviceProvider', {
                _id: true,
                name: true,
                userName: true,
                profilePic: true
            })
            .populate('user', {
                _id: true,
                name: true,
                userName: true,
                profilePic: true
            })
            .select('-updatedAt')
            .sort(sortBy(req.query.sort));


        if (req.query.serach_customer) {
            const complaintsList = [];
            const fuse = new Fuse(complaints, customerOptions);

            fuse.search(req.query.serach_customer).forEach(complaint => {
                complaintsList.push(complaint.item);
            });

            complaints = complaintsList;
        }

        if (req.query.serach_serviceProvider) {
            const complaintsList = [];
            const fuse = new Fuse(complaints, serviceProviderOptions);

            fuse.search(req.query.serach_serviceProvider).forEach(complaint => {
                complaintsList.push(complaint.item);
            });
            complaints = complaintsList;
        }


        if (complaints.length === 0)
            return res.status(200).json({
                status: 'Failed',
                message: 'No Complaints Was Found.'
            });


        res.status(200).json({
            count: complaints.length,
            complaints: complaints
        });
        
    } catch (err) {
        res.status(500).json({
            message: err.message
        });
    }
};



function sortBy(sortFactor) {
    switch (sortFactor) {
        case 'date_asc':
            return { createdAt: 1 };
        case 'date_desc':
            return { createdAt: -1 };
        default:
            return { _id: 1 };
    }
}