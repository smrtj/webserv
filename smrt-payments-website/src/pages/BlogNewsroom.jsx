import React from 'react';
import { getBlogPosts } from '../lib/contentful';

const BlogNewsroom = () => {
  const [posts, setPosts] = React.useState([]);

  React.useEffect(() => {
    getBlogPosts().then(setPosts).catch(console.error);
  }, []);

  return (
    <div className="bg-smrt-green-100 min-h-screen p-6">
      <h1 className="text-3xl font-bold text-smrt-green-600">Blog & Newsroom</h1>
      <section className="mt-6">
        <h2 className="text-2xl">Latest Updates</h2>
        <div className="mt-4">
          {posts.map((post) => (
            <article key={post.id} className="p-4 bg-white rounded-lg shadow mb-4">
              <h3 className="text-xl font-bold">{post.title}</h3>
              <p>{post.excerpt}</p>
            </article>
          ))}
        </div>
      </section>
    </div>
  );
};

export default BlogNewsroom;
