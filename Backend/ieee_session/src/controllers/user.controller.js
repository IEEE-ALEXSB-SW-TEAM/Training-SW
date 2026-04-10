import { findById } from "../models/user.model.js";

export default async function me(req,res, next) {
    try {
        const user = await findById(req.user.userId);
        if (!user) {  return res.status(404).json({ error: 'User not found' }); }
        res.json({user});
    } catch (e) {
        next(e);   
    }  
}