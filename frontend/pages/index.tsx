import Head from 'next/head';
import Layout, { siteTitle } from '../components/layout';
import utilStyles from '../styles/utils.module.css';
import { getSortedPostsData } from '../lib/posts';
import Link from 'next/link';
import Date from '../components/date';
import { GetStaticProps } from 'next';
import TopNav from '../components/TopNav';
import { Hero } from '../components/Hero';
import { Footer } from '../components/Footer';
import { Features } from '../components/Features';
import { Team } from '../components/Team';
import { Sponsors } from '../components/Sponsors';
import { Faqs } from '../components/Faqs';




export default function Home({
  allPostsData,
}: {
  allPostsData: {
    date: string;
    title: string;
    id: string;
  }[];
}) {
  return (
    <>
     <TopNav />
     <Hero/>
     <Features />
     <Faqs />
     <Team />

     <Sponsors />
    
    <Footer />
    </>
   
   
  );
}

export const getStaticProps: GetStaticProps = async () => {
  const allPostsData = getSortedPostsData();
  return {
    props: {
      allPostsData,
    },
  };
};
