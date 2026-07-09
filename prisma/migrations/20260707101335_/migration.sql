-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "AttendanceStatus" ADD VALUE 'LATE_PRESENT';
ALTER TYPE "AttendanceStatus" ADD VALUE 'HALF_DAY_LEAVE_HALF_DAY_PRESENT';
ALTER TYPE "AttendanceStatus" ADD VALUE 'HOLIDAY';
ALTER TYPE "AttendanceStatus" ADD VALUE 'WEEK_OFF';
ALTER TYPE "AttendanceStatus" ADD VALUE 'HOLIDAY_WORKED';
ALTER TYPE "AttendanceStatus" ADD VALUE 'WEEK_OFF_WORKED';
ALTER TYPE "AttendanceStatus" ADD VALUE 'PENDING_CORRECTION';
