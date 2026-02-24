import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  // Simulate 50 concurrent users constantly hitting the API for 3 minutes
  vus: 50,
  duration: '3m',
};

export default function () {
  http.get('http://130.211.26.247/cpu-stress');
  sleep(1);
}