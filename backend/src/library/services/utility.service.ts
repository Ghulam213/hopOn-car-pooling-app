import { Injectable } from '@nestjs/common';
import Handlebars from 'handlebars';

export interface LocalizedDtoInterface {
  locales: LocalizationInterface[];
}

export interface LocalizationInterface {
  locale: string;
}

@Injectable()
export class UtilityService {
  public static compileHandleBarTemplate(content: string, contentVars: any): string {
    const template = Handlebars.compile(content);
    return template(contentVars);
  }

  public static getKmDistanceBetweenTwoPoints(pointA: number[], pointB: number[]) {
    const lat1 = pointA[0];
    const lon1 = pointA[1];
    const lat2 = pointB[0];
    const lon2 = pointB[1];
    const R = 6371; // Radius of the earth in km
    const dLat = UtilityService.deg2rad(lat2 - lat1); // deg2rad below
    const dLon = UtilityService.deg2rad(lon2 - lon1);
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(UtilityService.deg2rad(lat1)) *
        Math.cos(UtilityService.deg2rad(lat2)) *
        Math.sin(dLon / 2) *
        Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    const d = R * c; // Distance in km
    return d;
  }

  public static deg2rad(deg: number) {
    return deg * (Math.PI / 180);
  }

  public static stringToCoordinates(data: string) {
    return data.split(',').map((item) => parseFloat(item));
  }

  public static getDistanceFromPointToLineSegment(point: number[], lineSegment: number[][]) {
    // calculate distance using cross-track method
    let [startPoint, endPoint] = lineSegment;
    let [startPointLng, startPointLat] = startPoint;
    let [endPointLng, endPointLat] = endPoint;
    let [pointLng, pointLat] = point;

    // Convert latitude and longitude to radians
    [pointLat, pointLng, startPointLat, startPointLng, endPointLat, endPointLng] = [
      pointLat,
      pointLng,
      startPointLat,
      startPointLng,
      endPointLat,
      endPointLng,
    ].map(this.deg2rad);

    // Calculate the cross-track distance of the point from the line segment
    const distance = Math.asin(
      Math.sin(pointLat - startPointLat) * Math.sin(endPointLng - startPointLng) +
        Math.cos(pointLat - startPointLat) * Math.cos(endPointLng - startPointLng) * Math.sin(pointLng - startPointLng),
    );
    const alongTrackDistance = Math.acos(Math.cos(pointLat - startPointLat) * Math.cos(distance)) * 6371; // Radius of the earth in kilometers

    // Check if the point is beyond the start or end of the line segment
    if (alongTrackDistance > UtilityService.getKmDistanceBetweenTwoPoints(startPoint, endPoint)) {
      return UtilityService.getKmDistanceBetweenTwoPoints(point, endPoint);
    } else if (alongTrackDistance < 0) {
      return UtilityService.getKmDistanceBetweenTwoPoints(point, startPoint);
    }
  }

  public static arePointsWithinThreshold(pointA: number[], pointB: number[], threshold: number) {
    const distanceInKm = UtilityService.getKmDistanceBetweenTwoPoints(pointA, pointB);
    return distanceInKm <= threshold;
  }

  public static isPointOnRouteWithinThreshold(point: number[], route: number[][], threshold: number) {
    for (let i = 0; i < route.length - 1; i++) {
      const lineSegment = [route[i], route[i + 1]];
      const distance = UtilityService.getDistanceFromPointToLineSegment(point, lineSegment);
      if (distance <= threshold) {
        return true;
      }
    }

    return false;
  }
}
