/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./frontend/**/*.{js,ts,jsx,tsx,mdx}",
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
 
    // Or if using `src` directory:
    "./src/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {},
  },
  rippleui: {
    themes: [
			{
				themeName: "light",
				colorScheme: "light",
				colors: {
					primary: "#235264",
					backgroundPrimary: "#964643",
				},
			},
			{
				themeName: "dark",
				colorScheme: "dark",
				colors: {
					primary: "#573242",
					backgroundPrimary: "#1a1a1a",
				},
			},
		],
		defaultStyle: false,
	},
  plugins: [require("rippleui")],
}