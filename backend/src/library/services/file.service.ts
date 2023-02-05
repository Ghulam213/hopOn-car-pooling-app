import { Inject, Injectable } from '@nestjs/common';
import { ConfigService, ConfigType } from '@nestjs/config';
import { S3 } from 'aws-sdk';
import { applicationConfig } from 'src/config';
import { tryCatchWrapper } from 'src/library/utils/tryCatchWrapper';

@Injectable()
export class FileService {
    private readonly s3: S3;

    constructor(
        @Inject(applicationConfig.KEY)
        private readonly appConfig: ConfigType<typeof applicationConfig>
    ) {
        this.s3 = new S3({
            accessKeyId: this.appConfig.awsAccessKeyId,
            secretAccessKey: this.appConfig.awsSecretAccessKey,
            region: this.appConfig.awsRegion,
        });
    }

    async uploadFile(key: string, file: Buffer): Promise<{ key: string; url: string }> {
        const params = {
            Bucket: this.appConfig.imageUploadBucket,
            Key: key,
            Body: file,
        };

        const uploadedFile = await this.s3.upload(params).promise();
        return {
          key: uploadedFile.Key,
          url: uploadedFile.Location,
        };
    }

    async getS3SignedUrl(key: string, contentType: string): Promise<string> {
        const params = {
            Bucket: this.appConfig.imageUploadBucket,
            Key: key,
            Expires: 60 * 15,
            ContentType: contentType,
        };

        const signedUrl = await this.s3.getSignedUrlPromise('putObject', params);
        return signedUrl;
    }

    async deleteFile(key: string): Promise<boolean> {
        const params = {
            Bucket: this.appConfig.imageUploadBucket,
            Key: key,
        };

        await this.s3.deleteObject(params).promise();
        return true;
    }

    async deleteFiles(keys: string[]): Promise<boolean> {
        const params = {
            Bucket: this.appConfig.imageUploadBucket,
            Delete: {
                Objects: keys.map((key) => ({ Key: key })),
            },
        };

        await this.s3.deleteObjects(params).promise();
        return true;
    }

    async getFile(key: string): Promise<Buffer> {
        const params = {
            Bucket: this.appConfig.imageUploadBucket,
            Key: key,
        };

        const data = await this.s3.getObject(params).promise();
        return data.Body as Buffer;
    }

    async getFileUrl(key: string): Promise<string> {
        const params = {
            Bucket: this.appConfig.imageUploadBucket,
            Key: key,
        };

        const data = await this.s3.getObject(params).promise();
        return data.Body as string;
    }

    async getFileSignedUrl(key: string): Promise<string> {
        const params = {
            Bucket: this.appConfig.imageUploadBucket,
            Key: key,
            Expires: 60 * 15,
        };

        const signedUrl = await this.s3.getSignedUrlPromise('getObject', params);
        return signedUrl;
    }

    async getFileUrls(keys: string[]): Promise<string[]> {
        const urls = await Promise.all(keys.map((key) => this.getFileUrl(key)));
        return urls;
    }

    async getFiles(keys: string[]): Promise<Buffer[]> {
        const files = await Promise.all(keys.map((key) => this.getFile(key)));
        return files;
    }
}