import * as contentful from 'contentful';

const client = contentful.createClient({
  space: process.env.VITE_CONTENTFUL_SPACE_ID,
  accessToken: process.env.VITE_CONTENTFUL_ACCESS_TOKEN,
});

export const getHomePageContent = async () => {
  const entries = await client.getEntries({ content_type: 'homePage' });
  return entries.items[0]?.fields || {};
};

export const getBlogPosts = async () => {
  const entries = await client.getEntries({ content_type: 'blogPost' });
  return entries.items.map(item => ({ id: item.sys.id, ...item.fields }));
};
