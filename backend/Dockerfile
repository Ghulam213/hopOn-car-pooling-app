FROM node:16.14-alpine AS deps

# Create directory for app
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

#Copy package.json & build npm dependencies
COPY package.json /usr/src/app/
COPY package-lock.json /usr/src/app/

RUN npm ci

####################
## Native Binaries Deps ##
####################
FROM node:16.14-alpine AS binaries-deps
RUN apk add --no-cache libc6-compat

WORKDIR /usr/src/app

# Prisma client
COPY --from=deps /usr/src/app/node_modules ./node_modules
COPY prisma ./prisma
RUN npx prisma generate --schema=./prisma/schema.prisma

#Copy App Source & build
COPY . /usr/src/app

RUN npm run build

EXPOSE 3001

# Run the service
CMD ["npm", "run", "start:prod"]