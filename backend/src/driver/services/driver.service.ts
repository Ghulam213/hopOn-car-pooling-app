import { Injectable } from "@nestjs/common";
import { PrismaService } from "src/prisma/services";

@Injectable()
export class DriverService {
    constructor(private prisma: PrismaService) {}
}