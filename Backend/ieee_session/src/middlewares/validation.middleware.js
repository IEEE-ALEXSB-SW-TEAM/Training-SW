export default function requireBody(fields) {
    return (req, res, next) => {
        if (!req.body || typeof req.body !== 'object') {
            return res.status(400).json({ error: 'Invalid request body. Must be a JSON object.' });
        }
        for (const field of fields) {
            if (!req.body[field]) {
                return res.status(400).json({ error: `${field} is required` });
            }
        }
        next();
    };
}