import TopNav from "../components/TopNav";
import { Hero } from "../components/Hero";
import { Footer } from "../components/Footer";
import { Features } from "../components/Features";
import { Team } from "../components/Team";
import { Faqs } from "../components/Faqs";

export default function Home() {
  return (
    <>
      <TopNav />
      <Hero />
      <Features />
      <Faqs />
      <Team />
      <Footer />
    </>
  );
}
