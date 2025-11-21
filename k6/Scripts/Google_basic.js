import { check, sleep } from 'k6';
import http from 'k6/http';

export const options = {
  vus: 10,
  duration: '30s',
};

export default function () {
  const res = http.get('http://google.com/');
  sleep(Math.random() * 2);
}