import type { Request, Response, NextFunction } from 'express';
import sharp from 'sharp';
import {
  findByEmail,
  createUser,
  findById,
  createResetToken,
  findResetToken,
  updateUserPassword,
  deleteResetTokensForUser,
  setProfilePicture,
  removeProfilePicture,
  getProfilePicture,
  type PublicUser,
  type AuthLookupUser,
} from '../models/user.model';
import { hashPassword, comparePassword } from '../utils/password';
import { signToken } from '../utils/jwt';
import { logger } from '../utils/logger';

const toPublicUserJson = (
  user: PublicUser | AuthLookupUser,
  req: Request
) => ({
  id: user.id,
  firstName: user.firstName,
  lastName: user.lastName,
  email: user.email,
  phoneNumber: user.phoneNumber,
  createdAt: user.createdAt,
  profilePictureUrl: user.hasProfilePicture
    ? `${req.protocol}://${req.get('host')}/api/auth/avatar/${user.id}`
    : null,
});


const AVATAR_DATA_URI = /^data:(image\/(?:png|jpe?g|webp));base64,(.+)$/i;

// --- Signup -----------------------------------------------------

export const signup = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const { firstName, lastName, email, phoneNumber, password } = req.body as {
      firstName: string;
      lastName: string;
      email: string;
      phoneNumber: string;
      password: string;
    };

    logger.info(`Signup attempt for email: ${email}`);

    const existing = await findByEmail(email);
    if (existing) {
      logger.warn(`Signup rejected: ${email} already exists`);
      res.status(409).json({
        success: false,
        message: 'An account with this email already exists',
      });
      return;
    }

    // --- Password harsh -----------------------------------------------------
    const passwordHash = await hashPassword(password);
    const user = await createUser({
      firstName,
      lastName,
      email,
      phoneNumber,
      passwordHash,
    });

    const token = signToken({ sub: user.id, email: user.email });
    logger.info(`User registered successfully: ID=${user.id}, email=${user.email}`);

    res.status(201).json({
      success: true,
      message: 'Account created successfully',
      data: { user: toPublicUserJson(user, req), token },
    });
  } catch (err) {
    logger.error('Error during signup processing:', err);
    next(err);
  }
};

// --- Login -----------------------------------------------------

export const login = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const { email, password } = req.body as { email: string; password: string };

    const user = await findByEmail(email);
    if (!user) {
      res.status(401).json({
        success: false,
        message: 'Invalid email or password',
      });
      return;
    }

    // --- Password compare -----------------------------------------------------
    const isMatch = await comparePassword(password, user.passwordHash);
    if (!isMatch) {
      res.status(401).json({
        success: false,
        message: 'Invalid email or password',
      });
      return;
    }

    const token = signToken({ sub: user.id, email: user.email });

    res.status(200).json({
      success: true,
      message: 'Login successful',
      data: {
        user: toPublicUserJson(user, req),
        token,
      },
    });
  } catch (err) {
    next(err);
  }
};

// --- Get logged in user -----------------------------------------------------

export const me = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const user = await findById(req.user!.sub);
    if (!user) {
      res.status(404).json({ success: false, message: 'User not found' });
      return;
    }
    res.status(200).json({ success: true, data: { user: toPublicUserJson(user, req) } });
  } catch (err) {
    next(err);
  }
};

// --- Forgot password -----------------------------------------------------

export const forgotPassword = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const { email } = req.body as { email: string };
    logger.info(`Forgot password request for email: ${email}`);

    const user = await findByEmail(email);
    if (!user) {
    
      res.status(200).json({
        success: true,
        message: 'If an account with that email exists, reset instructions have been sent.',
      });
      return;
    }

    const resetToken = await createResetToken(user.id);
    logger.info(`Password reset token created for ${email}: ${resetToken}`);

    res.status(200).json({
      success: true,
      message: 'Password reset code has been sent to your email.',
      data: { resetToken },
    });
  } catch (err) {
    logger.error('Error in forgotPassword:', err);
    next(err);
  }
};

// --- Reset password -----------------------------------------------------

export const resetPassword = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const { email, token, password } = req.body as {
      email: string;
      token: string;
      password: string;
    };
    logger.info(`Password reset attempt for email: ${email}`);

    const user = await findByEmail(email);
    if (!user) {
      res.status(400).json({
        success: false,
        message: 'Invalid email or reset code',
      });
      return;
    }

    const resetRecord = await findResetToken(token);
    if (!resetRecord || resetRecord.userId !== user.id) {
      res.status(400).json({
        success: false,
        message: 'Invalid or expired reset code',
      });
      return;
    }

    if (new Date() > new Date(resetRecord.expiresAt)) {
      res.status(400).json({
        success: false,
        message: 'Reset code has expired. Please request a new one.',
      });
      return;
    }

    const passwordHash = await hashPassword(password);
    await updateUserPassword(user.id, passwordHash);
    await deleteResetTokensForUser(user.id);

    logger.info(`Password reset successfully for email: ${email}`);

    res.status(200).json({
      success: true,
      message: 'Password reset successfully. You can now log in with your new password.',
    });
  } catch (err) {
    logger.error('Error in resetPassword:', err);
    next(err);
  }
};

// --- Profile picture -----------------------------------------------------

export const uploadAvatar = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const { image } = req.body as { image: string };
  
    const match = AVATAR_DATA_URI.exec(image.trim());
    if (!match) {
      res.status(400).json({ success: false, message: 'Invalid image data' });
      return;
    }

    const inputBuffer = Buffer.from(match[2], 'base64');

    let outputBuffer: Buffer;
    try {
      outputBuffer = await sharp(inputBuffer)
        .resize(512, 512, { fit: 'cover' })
        .png()
        .toBuffer();
    } catch (conversionError) {
      logger.warn('Rejected avatar upload: could not be decoded as an image', conversionError);
      res.status(400).json({
        success: false,
        message: 'That file could not be read as an image',
      });
      return;
    }

    await setProfilePicture(req.user!.sub, outputBuffer.toString('base64'));
    const user = await findById(req.user!.sub);
    if (!user) {
      res.status(404).json({ success: false, message: 'User not found' });
      return;
    }

    logger.info(`Profile picture updated for user ${req.user!.sub}`);
    res.status(200).json({
      success: true,
      message: 'Profile picture updated',
      data: { user: toPublicUserJson(user, req) },
    });
  } catch (err) {
    logger.error('Error in uploadAvatar:', err);
    next(err);
  }
};

export const deleteAvatar = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    await removeProfilePicture(req.user!.sub);
    const user = await findById(req.user!.sub);
    if (!user) {
      res.status(404).json({ success: false, message: 'User not found' });
      return;
    }

    logger.info(`Profile picture removed for user ${req.user!.sub}`);
    res.status(200).json({
      success: true,
      message: 'Profile picture removed',
      data: { user: toPublicUserJson(user, req) },
    });
  } catch (err) {
    logger.error('Error in deleteAvatar:', err);
    next(err);
  }
};

export const getAvatar = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const { userId } = req.params as { userId: string };
    const base64Png = await getProfilePicture(userId);
    if (!base64Png) {
      res.status(404).json({ success: false, message: 'No profile picture set for this user' });
      return;
    }

    const buffer = Buffer.from(base64Png, 'base64');
    res.setHeader('Content-Type', 'image/png');
    res.setHeader('Cache-Control', 'private, max-age=300');
    res.status(200).send(buffer);
  } catch (err) {
    next(err);
  }
};