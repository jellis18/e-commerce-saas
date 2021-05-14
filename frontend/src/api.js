import axios from 'axios';

const baseURL = process.env.API_BASE_URL || 'http://localhost:8000';

export const api = () => {
  let api = axios.create({ baseURL: baseURL });
  return api;
};
