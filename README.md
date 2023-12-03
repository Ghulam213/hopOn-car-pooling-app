# HopOn - Car Pooling Application #

This project is a car pooling application designed to address the growing commute issues in Pakistan. With the increase in population and urbanization, traffic congestion and commute times have become a significant problem. This application aims to provide a solution by facilitating car pooling, which can reduce the number of vehicles on the road, leading to less traffic and shorter commute times.

The application allows users to share their vehicle with others traveling in the same direction. Users can either offer a ride or request a ride. By matching ride offers and requests, the application optimizes routes and ensures that riders are picked up and dropped off at their preferred locations.

The application also includes features to ensure safety and trust among users. For example, users can rate each other based on their experience, can choose which gender they want to travel with, and profiles include verified information.

By using this application, users can not only save time and money on their daily commute, but also contribute to reducing traffic congestion and air pollution in Pakistan.


### Technologies Used ###

This project uses the following technologies:

* Flutter
* NestJS - REST APIs
* Redis
* AWS - Cognito, SNS, SQS, S3
* Prisma
* RxJS

## Getting Started

This section provides a step-by-step guide on how to set up and run the project.

### Prerequisites

Ensure you have the following installed on your local machine:

- Node.js
- Flutter
- Docker

### Setup

1. **Clone the repository** to your local machine using `git clone <repository-link>`.

2. **Navigate to the project directory** using `cd <project-directory>`.

3. **Install the dependencies** for both the backend and frontend.

      For the backend, navigate to the backend directory and run `npm install`:

      ```bash
      cd backend
      npm i
      ```

      For the frontend, navigate to the frontend directory and run `flutter packages get`:

      ```bash
      cd frontend
      flutter packages get
      ```

4. **Set up the database**. Navigate back to the backend directory and start the Docker container:
  
      ```bash
      cd ../backend
      docker-compose up -d
      ```

5. **Run the project**. You can start both the backend and frontend with the following commands:
  
      For the backend, run the start-dev.sh script:

      ```bash
      ./start-dev.sh
      ```

      For the frontend, navigate to the frontend directory and run `flutter run`:

      ```bash
      cd ../frontend
      flutter run
      ```

