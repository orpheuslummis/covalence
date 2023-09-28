export const Faqs = () => {
  return (
    <>
      <div className="max-w-[85rem] px-4 py-10 sm:px-6 lg:px-8 lg:py-14 mx-auto">
        <div className="max-w-2xl mx-auto text-center mb-10 lg:mb-14">
          <h2
            id="faq"
            className="text-2xl font-bold md:text-3xl md:leading-tight text-gray-800 dark:text-gray-200"
          >
            Frequently Asked Questions
          </h2>
        </div>

        <div className="max-w-5xl mx-auto">
          <div className="grid sm:grid-cols-2 gap-6 md:gap-12">
            <div>
              <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-200">
                What is Covalence?
              </h3>
              <p className="mt-2 text-gray-600 dark:text-gray-400">
                Covalence revolutionizes the way value is allocated and
                distributed. Our technology allows groups to select customizable
                valuation methodologies, execute them privately via homomorphic
                encryption, and transform assets into ownership tables.
                Covalence is an ecosystem designed for excellence in value
                distribution.
              </p>
            </div>

            <div>
              <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-200">
                What features does Covalence offer?
              </h3>
              <p className="mt-2 text-gray-600 dark:text-gray-400">
                Covalence offers features like Custom Methodologies, Privacy,
                Multi-Round Valuation, Public or Private Outputs, and a Web App.
              </p>
            </div>

            <div>
              <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-200">
                What are some use cases for Covalence?
              </h3>
              <p className="mt-2 text-gray-600 dark:text-gray-400">
                Covalence can be used for Asset Ownership, Corporate and DAO
                Management, Fund Accounting, and Dynamic Incentives.
              </p>
            </div>

            <div>
              <h3 className="text-lg font-semibold text-gray-800 dark:text-gray-200">
                How can I contribute to Covalence?
              </h3>
              <p className="mt-2 text-gray-600 dark:text-gray-400">
                You can contribute by becoming a community leader, a technical
                contributor, or a financial backer. All contributions are
                recognized and rewarded through Covalence's valuation
                methodologies.
              </p>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};
