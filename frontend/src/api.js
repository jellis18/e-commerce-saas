import axios from 'axios';

// need this for docker/kubernetes deployment
const baseURL = 'API_BASE_URL_PLACEHOLDER';
const defaultOptions = {
  baseURL: baseURL.includes('PLACEHOLDER') ? process.env.API_BASE_URL : baseURL,
};

export const api = () => {
  let api = axios.create({ baseURL: defaultOptions.baseURL });
  return api;
};
