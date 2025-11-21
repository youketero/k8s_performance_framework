import { check, sleep } from 'k6';
import http from 'k6/http';

// ENVIRONENT VARIABLES AND CONST PARAMETERS 
  const url = `http://${__ENV.HOSTNAME}:${__ENV.PORT}`
  const PRODUCTS_NUM = Number(__ENV.PRODUCTS_NUM ?? 100)
  const PRODUCTS_PAGES_NUM = Number(__ENV.PRODUCTS_PAGES_NUM ?? 3)
  const USERS_NUM = Number(__ENV.USERS_NUM ?? 10)
  const PRODUCTS_PER_PAGE = Number(__ENV.PRODUCTS_PER_PAGE ?? 100)
  const PERCENT_PRODUCTS_ADDED_TO_CART = Number(__ENV.PERCENT_PRODUCTS_ADDED_TO_CART ?? 20)
  let params = {
      headers: {
        'Content-Type': 'application/json',
      },
    };

  let payload = ""

// TEST PROFILE

export const options = {
  vus: 2,
  duration: '5s',
};

// TEST SETUP 

export function setup() {

  for (let i = 0; i < USERS_NUM; i++) {
      payload = JSON.stringify({
      "id": getRandomInt(100, 999),
      "email": getRandomString(10) + "@example.com",
      "username": getRandomString(8),
      "password": getRandomString(12),
      "name": {
        "firstname": getRandomString(6),
        "lastname": getRandomString(8)
      },
      "phone": "+380-" + getRandomInt(10, 99) + "-" + getRandomInt(100, 999) + "-" + getRandomInt(100, 999),
      "address": {
        "geolocation": {
          "lat": getRandomInt(-99, 99).toString(),
          "long": getRandomInt(-99, 99).toString()
        },
        "city": getRandomString(6),
        "street": getRandomString(10),
        "number": getRandomInt(10, 100),
        "zipcode": getRandomInt(10000, 99999).toString()
      }
    })
    http.post(`${url}/users`, payload, params)
  }
  const users = JSON.parse(http.get(`${url}/users`).body)
  const usernames = users.map(u => ({ username: u.username, password: u.password }));
  const login_response = JSON.parse(http.post(`${url}/login`, JSON.stringify(usernames[0]), params).body)
  for (let i = 0; i <= PRODUCTS_NUM; i++) {
    payload = JSON.stringify({
      "title": getRandomString(20),
      "price": getRandomInt(10, 1000),
      "description": getRandomString(100),
      "category": getRandomString(10),
      "image": "image.img",
      "rating": {
        "rate": getRandomInt(1, 10),
        "count": getRandomInt(10, 100)
      }
    })

  params.headers.Authorization = 'Bearer ' + login_response.token
  http.post(`${url}/products`, payload, params)
  }
 
}


// TEST MAIN

export default function () {
  const user = http.get(`${url}/users/${__VU}`);
  check(user, {
    'is status 200': (r) => r.status === 200,
  });
  const username = JSON.stringify({ "username": JSON.parse(user.body).username, "password": JSON.parse(user.body).password });
  const login_response = JSON.parse(http.post(`${url}/login`, username, params).body)
  params.headers.Authorization = 'Bearer ' + login_response.token
  payload = JSON.stringify({
      "date": getTimestamp() + "",
      "userId": __VU,
      "products": []
    })
  const cart_response = JSON.parse(http.post(`${url}/carts`, payload, params).body)
  for(let i=0; i < PRODUCTS_PAGES_NUM; i++){
     http.get(`${url}/products`, params)
     for(let i=0; i < PRODUCTS_PER_PAGE; i++){
        let product_id = http.get(`${url}/products/` + getRandomInt(1, PRODUCTS_NUM), params)
        product_id = JSON.parse(product_id.body).id
        if (getRandomInt(1, 100) < PERCENT_PRODUCTS_ADDED_TO_CART){
          let cart_response_body = JSON.parse(http.get(`${url}/carts/` + cart_response.id, params).body)
          //Check that selected product in the cart presented
          const existingProduct = cart_response_body.products.find(u => u.productId == product_id)
          if (existingProduct){
            existingProduct.quantity++
            }else{
              cart_response_body.products.push({"productId": product_id,"quantity":1})
            }
            http.put(`${url}/carts/` + cart_response.id, JSON.stringify(cart_response_body), params)
        }
     }
  }
}

// TEST TEARDOWN

export function teardown() {
  const url = "http://localhost:30000/reset_mock"

  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  http.post(url, null, params)

}

// CUSTOM FUNCTIONS

function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}

function getRandomString(length) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  let result = '';
  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
}

function getTimestamp() {
    const now = new Date();
    const yyyy = now.getUTCFullYear();
    const MM = String(now.getUTCMonth() + 1).padStart(2, '0');
    const dd = String(now.getUTCDate()).padStart(2, '0');
    const HH = String(now.getUTCHours()).padStart(2, '0');
    const mm = String(now.getUTCMinutes()).padStart(2, '0');
    const ss = String(now.getUTCSeconds()).padStart(2, '0');
    const mmm = String(now.getUTCMilliseconds()).padStart(3, '0');
    return `${yyyy}-${MM}-${dd}T${HH}:${mm}:${ss}.${mmm}Z`;
}

//function getTimestamp() {
  //const date = new Date().toISOString();
 // console.log(date)
 // return date;
//}