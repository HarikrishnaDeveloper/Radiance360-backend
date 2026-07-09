/*
  Warnings:

  - The values [LATE,SUNDAY] on the enum `AttendanceStatus` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `permission` on the `attendance` table. All the data in the column will be lost.
  - You are about to drop the column `permissionApprovedById` on the `attendance` table. All the data in the column will be lost.
  - You are about to drop the column `permissionReason` on the `attendance` table. All the data in the column will be lost.
  - You are about to drop the column `permissionType` on the `attendance` table. All the data in the column will be lost.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "AttendanceStatus_new" AS ENUM ('NOT_MARKED', 'PRESENT', 'LATE_PRESENT', 'ABSENT', 'HALF_DAY', 'LEAVE', 'HALF_DAY_LEAVE_PRESENT', 'HOLIDAY', 'WEEK_OFF', 'HOLIDAY_WORKED', 'WEEK_OFF_WORKED', 'PENDING');
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

-- DropForeignKey
ALTER TABLE "attendance" DROP CONSTRAINT "attendance_permissionApprovedById_fkey";

-- AlterTable
ALTER TABLE "attendance" DROP COLUMN "permission",
DROP COLUMN "permissionApprovedById",
DROP COLUMN "permissionReason",
DROP COLUMN "permissionType";

-- CreateTable
CREATE TABLE "permissions" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "date" DATE NOT NULL,
    "type" "PermissionType" NOT NULL,
    "status" "PermissionStatus" NOT NULL DEFAULT 'PENDING',
    "reason" TEXT NOT NULL,
    "approvedById" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "permissions_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "permissions" ADD CONSTRAINT "permissions_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "permissions" ADD CONSTRAINT "permissions_approvedById_fkey" FOREIGN KEY ("approvedById") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
