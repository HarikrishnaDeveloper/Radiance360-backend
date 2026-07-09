/*
  Warnings:

  - The values [HALF_DAY_LEAVE_HALF_DAY_PRESENT,PENDING_CORRECTION] on the enum `AttendanceStatus` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "AttendanceStatus_new" AS ENUM ('NOT_MARKED', 'PRESENT', 'LATE_PRESENT', 'ABSENT', 'LATE', 'HALF_DAY', 'LEAVE', 'HALF_DAY_LEAVE_PRESENT', 'HOLIDAY', 'WEEK_OFF', 'HOLIDAY_WORKED', 'WEEK_OFF_WORKED', 'PENDING', 'SUNDAY');
ALTER TABLE "attendance" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "attendance" ALTER COLUMN "status" TYPE "AttendanceStatus_new" USING ("status"::text::"AttendanceStatus_new");
ALTER TABLE "attendance_audit_logs" ALTER COLUMN "oldStatus" TYPE "AttendanceStatus_new" USING ("oldStatus"::text::"AttendanceStatus_new");
ALTER TABLE "attendance_audit_logs" ALTER COLUMN "newStatus" TYPE "AttendanceStatus_new" USING ("newStatus"::text::"AttendanceStatus_new");
ALTER TABLE "attendance_correction_requests" ALTER COLUMN "requestedStatus" TYPE "AttendanceStatus_new" USING ("requestedStatus"::text::"AttendanceStatus_new");
ALTER TYPE "AttendanceStatus" RENAME TO "AttendanceStatus_old";
ALTER TYPE "AttendanceStatus_new" RENAME TO "AttendanceStatus";
DROP TYPE "AttendanceStatus_old";
ALTER TABLE "attendance" ALTER COLUMN "status" SET DEFAULT 'NOT_MARKED';
COMMIT;
