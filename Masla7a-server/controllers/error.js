exports._404 = (req, res, next) => {
  res.status(404).json({
    pageTitle: 'Page Not Found',
    message: 'Sorry, Page Not Found'
  });
};

exports.handlingError = (req, res, next) => {
  const err = new Error('Route is not found')
  err.status = 404
  next(error);
};

exports.serverErrorHandler = (error, req, res, next) => {
  const status = error.status || 500;
  res.status(status).send(error.message);
};