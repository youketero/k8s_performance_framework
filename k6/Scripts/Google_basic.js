import { check, sleep } from 'k6';
import http from 'k6/http';

export const options = {
  thresholds: {
    http_req_failed: ['rate< 0.01'],
    http_req_duration: ['p(95)<500'],
  },
  vus: 10,
  duration: '30s',
};

export default function () {
  const res = http.get('http://google.com/');
  sleep(Math.random() * 2);
}
