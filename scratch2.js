const { PrismaClient } = require('./node_modules/@prisma/client');
const prisma = new PrismaClient();

async function check() {
  const t = await prisma.attendance.findMany({
    orderBy: { createdAt: 'desc' },
    take: 1
  });
  console.log(t);
  process.exit(0);
}
check();
