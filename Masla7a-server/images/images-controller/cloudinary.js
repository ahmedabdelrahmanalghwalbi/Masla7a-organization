
const cloudinary = require('cloudinary');

cloudinary.config({
    cloud_name:'maslaha-app',
    api_key:'937232449976274',
    api_secret:'1rrOUsuBZ80ET2XF4K8yYUTQxak'
});

exports.uploads = (file)=>{
    return new Promise(resolve=>{
        cloudinary.uploader.upload(file, (result=>{
        resolve({url: result.url, id: result.public_id});
        }), {resource_type:"auto"});
    })
}