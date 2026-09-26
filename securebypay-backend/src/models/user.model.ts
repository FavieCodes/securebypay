import { eq, sql } from 'drizzle-orm';
import { db } from '../db';
import { users, passwordResetTokens, type User } from '../db/schema';
import { withReadRetry } from '../utils/dbRetry';

type BaseUserFields = Pick<
  User,
  'id' | 'firstName' | 'lastName' | 'email' | 'phoneNumber' | 'createdAt'
>;


export interface PublicUser extends BaseUserFields {
  hasProfilePicture: boolean;
}
export interface AuthLookupUser extends BaseUserFields {
  passwordHash: string;
  hasProfilePicture: boolean;
}

export const findByEmail = async (email: string): Promise<AuthLookupUser | null> => {
  return withReadRetry(async () => {
    const rows = await db
      .select({
        id: users.id,
        firstName: users.firstName,
        lastName: users.lastName,
        email: users.email,
        phoneNumber: users.phoneNumber,
        passwordHash: users.passwordHash,
        createdAt: users.createdAt,
        hasProfilePicture: sql<boolean>`${users.profilePicture} is not null`,
      })
      .from(users)
      .where(eq(users.email, email.toLowerCase()))
      .limit(1);
    return rows[0] ?? null;
  });
};

export const findById = async (id: string): Promise<PublicUser | null> => {
  return withReadRetry(async () => {
    const rows = await db
      .select({
        id: users.id,
        firstName: users.firstName,
        lastName: users.lastName,
        email: users.email,
        phoneNumber: users.phoneNumber,
        createdAt: users.createdAt,
        hasProfilePicture: sql<boolean>`${users.profilePicture} is not null`,
      })
      .from(users)
      .where(eq(users.id, id))
      .limit(1);
    return rows[0] ?? null;
  });
};

interface CreateUserInput {
  firstName: string;
  lastName: string;
  email: string;
  phoneNumber: string;
  passwordHash: string;
}

export const createUser = async ({
  firstName,
  lastName,
  email,
  phoneNumber,
  passwordHash,
}: CreateUserInput): Promise<PublicUser> => {
  const rows = await db
    .insert(users)
    .values({
      firstName,
      lastName,
      email: email.toLowerCase(),
      phoneNumber,
      passwordHash,
    })
    .returning({
      id: users.id,
      firstName: users.firstName,
      lastName: users.lastName,
      email: users.email,
      phoneNumber: users.phoneNumber,
      createdAt: users.createdAt,
    });

  return { ...rows[0], hasProfilePicture: false };
};

export const createResetToken = async (userId: string): Promise<string> => {
  await db
    .delete(passwordResetTokens)
    .where(eq(passwordResetTokens.userId, userId));

  const token = Math.floor(100000 + Math.random() * 900000).toString();
  const expiresAt = new Date(Date.now() + 60 * 60 * 1000); // 1 hour expiration

  await db.insert(passwordResetTokens).values({
    userId,
    token,
    expiresAt,
  });

  return token;
};

export const findResetToken = async (token: string) => {
  return withReadRetry(async () => {
    const rows = await db
      .select()
      .from(passwordResetTokens)
      .where(eq(passwordResetTokens.token, token))
      .limit(1);

    return rows[0] ?? null;
  });
};

export const updateUserPassword = async (
  userId: string,
  passwordHash: string
): Promise<void> => {
  await db
    .update(users)
    .set({ passwordHash })
    .where(eq(users.id, userId));
};

export const deleteResetTokensForUser = async (userId: string): Promise<void> => {
  await db
    .delete(passwordResetTokens)
    .where(eq(passwordResetTokens.userId, userId));
};

// --- Profile picture ---------------------------------------------------


export const setProfilePicture = async (
  userId: string,
  base64Png: string
): Promise<void> => {
  await db
    .update(users)
    .set({ profilePicture: base64Png })
    .where(eq(users.id, userId));
};

export const removeProfilePicture = async (userId: string): Promise<void> => {
  await db
    .update(users)
    .set({ profilePicture: null })
    .where(eq(users.id, userId));
};

/** Returns the stored base64 PNG data, or null if the user has none. */
export const getProfilePicture = async (userId: string): Promise<string | null> => {
  return withReadRetry(async () => {
    const rows = await db
      .select({ profilePicture: users.profilePicture })
      .from(users)
      .where(eq(users.id, userId))
      .limit(1);

    return rows[0]?.profilePicture ?? null;
  });
};