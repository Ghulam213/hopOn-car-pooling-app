import { Inject, Injectable } from '@nestjs/common';
import { SNS } from 'aws-sdk';
import { applicationConfig } from 'src/config';
import { ConfigType } from '@nestjs/config';

/*
 * This service for handling notifications via AWS SNS.
 * It will be used for publishing messages to SNS topics
 * and handling other SNS related tasks. We will interact
 * with SNS via the AWS SDK for JavaScript.
 *
 * @docs AWS SDK: https://docs.aws.amazon.com/sdk-for-javascript/index.html
 * @docs AWS SDK SNS: https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/SNS.html
 */

type TopicType = 'rideRequest';
type NotificationPayload<T> = {
  subject: string;
  message: T;
};

@Injectable()
export class NotificationService {
  private sns: SNS;

  constructor(
    @Inject(applicationConfig.KEY)
    private readonly appConfig: ConfigType<typeof applicationConfig>,
  ) {
    this.sns = new SNS({
      region: this.appConfig.awsRegion,
      accessKeyId: this.appConfig.awsAccessKeyId,
      secretAccessKey: this.appConfig.awsSecretAccessKey,
    });
  }

  public getTopicArnFromTopicType(topicType: TopicType) {
    switch (topicType) {
      case 'rideRequest':
        return this.appConfig.awsSnsTopicType.rideRequest;
    }
  }

  async publishMessageToTopic<T>(payload: NotificationPayload<T>, topicType: TopicType) {
    const params = {
      Message: JSON.stringify(payload.message),
      Subject: payload.subject,
      TopicArn: this.getTopicArnFromTopicType(topicType),
    };

    return this.sns.publish(params).promise();
  }

  async publishMessageToDeviceArn<T>(payload: NotificationPayload<T>, deviceArn: string) {
    const params = {
      Message: JSON.stringify(payload.message),
      Subject: payload.subject,
      TargetArn: deviceArn,
    };

    return this.sns.publish(params).promise();
  }

  async createApplicationPlatformEndpoint(deviceToken: string) {
    const params = {
      PlatformApplicationArn: this.appConfig.awsSnsPlatformApplicationArn,
      Token: deviceToken,
    };

    return this.sns.createPlatformEndpoint(params).promise();
  }

  async subscribeEndpointToTopic(endpointArn: string, topicType: TopicType) {
    const params = {
      Endpoint: endpointArn,
      Protocol: 'application',
      TopicArn: this.getTopicArnFromTopicType(topicType),
    };

    return this.sns.subscribe(params).promise();
  }
}
