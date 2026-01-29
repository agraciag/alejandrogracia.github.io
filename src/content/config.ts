import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const projects = defineCollection({
  loader: glob({ pattern: "**/*.{md,mdx}", base: "./src/content/projects" }),
  schema: ({ image }) => z.object({
    title: z.string(),
    description: z.string(),
    client: z.string().optional(),
    date: z.date().optional(),
    tags: z.array(z.string()).optional(),
    cover: image().optional(),
    coverAlt: z.string().optional(),
    featured: z.boolean().default(false),
  }),
});

export const collections = { projects };
