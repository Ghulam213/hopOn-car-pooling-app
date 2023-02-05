import { Controller } from "@nestjs/common";
import { DriverService } from "src/driver/services";

@Controller()
export class DriverController {
    constructor(private readonly driverService: DriverService) {}
}