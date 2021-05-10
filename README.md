# Image Repository API

The image repository uses Ruby on Rails and GraphQL Files are stored using ActiveStorage

The API allows:

- Create a User
- Sign in
- Get an Image by ID
- Get multiple Images by seaching
- Create an Image
- Update an Image
- Delete an Image
- Delete multiple Images

All images are considered public and users can access all images that are created. Users must be signed in to create an image and can only update or delete their own images.

##### Table of Contents

[Setup](#setup)  
[Types](#types)
[Queries (with examples)](#queries)
[Mutations (with examples)](#mutations)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Create a user](#create-a-user)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Sign in a user](#sign-in-a-user)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Create an image](#create-an-image)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Update an image](#update-an-image)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Delete an image](#delete-an-image)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[Delele multiple images](#delete-multiple-images)

## Setup

To run this repo locally.

1. Clone this repo

```
git clone https://github.com/meghanlo/shopify-challenge.git
cd shopify-challenge/
```

2. (Optional) Run the `setup_shopify.cmd` file to install any missing dependecies

3. `gem install bundler`
4. `bundle install`
5. `bundle exec rake db:setup`
6. `bundle exec rails rspec`
7. Start the server `bin/rails server`
8. Download [Insomnia](https://insomnia.rest/download)
9. Open insomnia and go to `http://localhost:3000/graphql`

#### Tests

To run tests:
`bundle exec rails rspec`

## Types

#### User

Fields

```GraphQL
email: String!
id: ID!
  canonical id of the user
name: String!
```

#### Image

Fields

```GraphQL
altText: String
  alternative text for the image
id: ID!
  canonical id of the image
imageUrl: String!
  link to access the image
name: String!
  title of the image
tags: [String!]
  keywords to identify images
user: User
  owner of the image
```

#### Errors

Fields

```GraphQL
field: String!
value: String!
```

## Queries

**POST** `/graphql`

<br/>
  
  1. Find image by image canonical id
  `image(id: ID!): Image`

```GRAPHQL
query {
  image (id:"image_canonical-vGolAi1LY3fGog"){
    id
    name
    altText
    imageUrl
    tags
    user {
      id
    }
  }
}
```

**JSON response**

```JSON
{
  "data": {
    "image": {
      "id": "image_canonical-FI-ohGqFKxiSOQ",
      "name": "Baby Yoda - Star Wars",
      "altText": "Grogu holding a cup",
      "imageUrl": "/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBVQT09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--9ce58f4db645429ecdb7d663fd370f752369c204/photo3.jpeg",
      "tags": [
        "star wars",
        "yoda",
        "cute"
      ],
      "user": {
        "id": "user_canonical-Y3dFBYztRyROEw",
        "name": "Luke Skywalker",
        "email": "jedi@email.com"
      }
    }
  }
}
```

<br/>

2. Find images by name or tags
   `images(name: String, tags: [String!]): [Image!]`

The following exmaple uses tags to search for images, but it also accepts `name`

```GRAPHQL
query {
  images(tags:["landscape"]){
    id
    name
    altText
    imageUrl
    tags
    user {
      id
      name
      email
    }
  }
}
```

**JSON response**

```JSON
{
  "data": {
    "images": [
      {
        "id": "image_canonical-o-BxbrRJWz6hww",
        "name": "sunset",
        "altText": "toronto skyline during sunset",
        "imageUrl": "/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBUZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--331522e3de72953526e4564c10e2e89814bb1ee3/photo.jpeg",
        "tags": [
          "landscape",
          "orange"
        ],
        "user": {
          "id": "user_canonical-OxruXDSQYxrOQ",
          "name": "Meghan Lo",
          "email": "example@email.com"
        }
      },
      {
        "id": "image_canonical-RXKHkjR3i575RQ",
        "name": "ocean",
        "altText": null,
        "imageUrl": "/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBUdz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--7e09c626d118fd6584c01edadc528dca9582fde3/photo2.jpeg",
        "tags": [
          "landscape",
          "blue",
          "water"
        ],
        "user": {
          "id": "user_canonical-OxruXDSQYxrOQ",
          "name": "Meghan Lo",
          "email": "example@email.com"
        }
      }
    ]
  }
}
```

<br/>

## Mutations

#### Create a user
**POST** `/graphql`

Input Fields

```GraphQL
name: String!
imageFile: Upload!
altText: String
tags: [String!]
```

**Query**

```GraphQL
mutation {
  createUserMutation (input: {name: "Meghan Lo", authProvider: { credentials: { email: "example@email.com", password: "SecurePassword" } } } ) {
    user{
      id
      email
      name
    }
    errors {
      field
      value
    }
  }
}
```

**JSON response**

```JSON
{
  "data": {
    "createUserMutation": {
      "user": {
        "id": "user_canonical-MbnOTGDaWRGRvg",
        "email": "example@email.com",
        "name": "Meghan Lo"
      },
      "errors": null
    }
  }
}
```


#### Sign in a user
**POST** `/graphql`

User must sign in and use the given token to do any mutations

Input Fields

```GraphQL
credentials: AUTH_PROVIDER_CREDENTIALS
  email: String!
  password: String!
```

**Query**

```GRAPHQL
mutation {
  signInUserMutation ( input: { credentials: { email: "example@email.com", password:"SecurePassword" } } ) {
    token
    user {
      id
      name
      email
    }
  }
}
```

**JSON response**

```JSON
{
  "data": {
    "signInUserMutation": {
      "token": "eyJhbGciOiJub25lIn0.eyJpZCI6NCwiZXhwIjoxNjIwNjE3MzY5fQ.",
      "user": {
        "id": "user_canonical-MbnOTGDaWRGRvg",
        "name": "Meghan Lo",
        "email": "example@email.com"
      }
    }
  }
}
```


#### Create an Image
**POST** `/graphql`

Since we are uploading files - a multipart form is used

The user must be signed in to upload an image

Input Fields

```GraphQL
name: String!
imageFile: Upload!
altText: String
tags: [String!]
```

**Query**

```GRAPHQL
mutation ($name: String!, $tags: [String]!, $imageFile: Upload!) {
  createImageMutation ( input: { name: $name, tags: $tags, imageFile: $imageFile } ) {
    image {
      id
      name
      altText
      imageUrl
      tags
      user {
        name
        email
      }
    }
    errors {
      field
      value
    }
  }
}
```

**Variables**

```JSON
"variables": {
    "name": "R2D2",
    "imageFile": null,
    "tags": [
      "star wars",
      "robot"
    ]
  }
```

**Mapping the Image File**

Using Insomnia, map the variable to the image file to be uploaded

![image](https://user-images.githubusercontent.com/37924402/117597658-e7ab2e00-b0fa-11eb-8a22-9333dacf767b.png)

**JSON response**

```JSON
{
  "data": {
    "createImageMutation": {
      "image": {
        "id": "image_canonical-bukjw7BhukGFYQ",
        "name": "R2D2",
        "altText": null,
        "imageUrl": "/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBVZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--d124b54052ac509dc360352c693ab0235d792d6e/r2d2.png",
        "tags": [
          "star wars",
          "robot"
        ],
        "user": {
          "name": "Meghan Lo",
          "email": "example@email.com"
        }
      },
      "errors": null
    }
  }
}
```

#### Update an Image
**POST** `/graphql`

Update an image's name, alternative text, or tags with this request. Only the owner of an image (the user who created the image) is allowed to update the image information

**Input Fields**

```GraphQL
id: ID!
name: String
altText: String
tags: [String!]
```

**Query**

```GRAPHQL
mutation {
  updateImageMutation( input: { id: "image_canonical-bukjw7BhukGFYQ", name: "new name", altText: null, tags: ["only have this tag"] } ) {
    image {
      id
      name
      imageUrl
      altText
      tags
      user {
        id
        name
        email
      }
    }
  	errors {
      field
      value
    }
  }
}
```

**JSON response**

```JSON
{
  "data": {
    "updateImageMutation": {
      "image": {
        "id": "image_canonical-bukjw7BhukGFYQ",
        "name": "new name",
        "imageUrl": "/rails/active_storage/blobs/redirect/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBVZz09IiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--d124b54052ac509dc360352c693ab0235d792d6e/r2d2.png",
        "altText": null,
        "tags": [
          "only have this tag"
        ],
        "user": {
          "id": "user_canonical-OxruXDSQYxrOQ",
          "name": "Meghan Lo",
          "email": "example@email.com"
        }
      },
      "errors": null
    }
  }
}
```

#### Delete an Image
**POST** `/graphql``

Only the owner of an image (the user who created the image) is allowed to delete the image

Input Fields

```GraphQL
id: ID!
```

**Query**

```GRAPHQL
mutation {
  deleteImageMutation (input: {id: "image_canonical-bukjw7BhukGFYQ"} ) {
		image
    errors {
      field
      value
    }
  }
}

```

**JSON response**

```JSON
{
  "data": {
    "deleteImageMutation": {
      "image": "image_canonical-bukjw7BhukGFYQ",
      "errors": null
    }
  }
}
```


#### Delete Multiple Images
**POST** `/graphql`

Only the owner of an image (the user who created the image) is allowed to delete the image

Input Fields

```GraphQL
id: [ID!]
```

**Query**

```GRAPHQL
mutation {
  deleteManyImageMutation (input: {id: ["image_canonical-qOrEmot-Hm9a9Q", "image_canonical-DAMC79B69JQbw"]} ) {
		images
    errors {
      field
      value
    }
  }
}
```

**JSON response**

```
{
  "data": {
    "deleteManyImageMutation": {
      "images": [
        "image_canonical-qOrEmot-Hm9a9Q",
        "image_canonical-DAMC79B69JQbw"
      ],
      "errors": null
    }
  }
}
```
