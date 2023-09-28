import Head from "next/head";
import utilStyles from "../styles/utils.module.css";
import Link from "next/link";
import Date from "../components/date";
import { GetStaticProps } from "next";
import TopNav from "../components/TopNav";
import { Hero } from "../components/Hero";
import { Footer } from "../components/Footer";
import { Features } from "../components/Features";
import { Team } from "../components/Team";
import { Sponsors } from "../components/Sponsors";
import { Faqs } from "../components/Faqs";

export default function Home() {
  return (
    <>
      <TopNav />
      <Hero />
      <Features />
      <Faqs />
      <Team />

      <Sponsors />

      <Footer />
    </>
  );
}
