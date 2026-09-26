import type { Request, Response, NextFunction } from 'express';
import { validationResult, body } from 'express-validator';

export const handleValidation = (
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    res.status(400).json({
      success: false,
      message: 'Validation failed',
      errors: errors.array().map((e) => ({
        field: 'path' in e ? e.path : undefined,
        message: e.msg,
      })),
    });
    return;
  }
  next();
};

export const signupRules = [
  body('firstName').trim().notEmpty().withMessage('First name is required'),
  body('lastName').trim().notEmpty().withMessage('Last name is required'),
  body('email').trim().isEmail().withMessage('A valid email is required'),
  body('phoneNumber').trim().notEmpty().withMessage('Phone number is required'),
  body('password')
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters long'),
];

export const loginRules = [
  body('email').trim().isEmail().withMessage('A valid email is required'),
  body('password').notEmpty().withMessage('Password is required'),
];

export const forgotPasswordRules = [
  body('email').trim().isEmail().withMessage('A valid email is required'),
];

export const resetPasswordRules = [
  body('email').trim().isEmail().withMessage('A valid email is required'),
  body('token').trim().notEmpty().withMessage('Reset code/token is required'),
  body('password')
    .isLength({ min: 8 })
    .withMessage('Password must be at least 8 characters long'),
];


const MAX_AVATAR_BASE64_LENGTH = 10 * 1024 * 1024; 

export const avatarUploadRules = [
  body('image')
    .trim()
    .notEmpty()
    .withMessage('An image is required')
    .custom((value: string) => {
      if (!/^data:image\/(png|jpe?g|webp);base64,.+$/i.test(value)) {
        throw new Error('Image must be a base64 data URI (png, jpg, or webp)');
      }
      if (value.length > MAX_AVATAR_BASE64_LENGTH) {
        throw new Error('Image is too large (max ~3MB)');
      }
      return true;
    }),
];