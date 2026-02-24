import http from 'k6/http';
import { sleep, check } from 'k6';

export const options = {
  vus: 10,       // 10 concurrent users
  duration: '5m', // Run for 5 minutes
};

export default function () {
  // Hit /health because we want to test availability, not CPU saturation
  const res = http.get('http://130.211.26.247/health');
  
  // Verify the application successfully returns a 200 OK
  check(res, {
    'is status 200': (r) => r.status === 200,
  });
  
  sleep(0.5);
}