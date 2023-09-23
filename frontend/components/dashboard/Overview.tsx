


export const Overview = () => {


    return (
        <>
        <h1 className="text-2xl font-bold text-center">Hi there, </h1>

<div className="max-w-5xl px-4 py-10 sm:px-6 lg:px-8 lg:py-14 mx-auto">
    <span className="font-bol text-xl py-5">Your Stats</span>

  <div className="grid sm:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6 mt-5">

    <a className="group flex flex-col bg-white border shadow-sm rounded-xl hover:shadow-md transition dark:bg-slate-900 dark:border-gray-800" href="#">
      <div className="p-4 md:p-5">
        <div className="flex">
          <svg className="mt-1 shrink-0 w-5 h-5 text-gray-800 dark:text-gray-200" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
            <path d="M15 14s1 0 1-1-1-4-5-4-5 3-5 4 1 1 1 1h8Zm-7.978-1A.261.261 0 0 1 7 12.996c.001-.264.167-1.03.76-1.72C8.312 10.629 9.282 10 11 10c1.717 0 2.687.63 3.24 1.276.593.69.758 1.457.76 1.72l-.008.002a.274.274 0 0 1-.014.002H7.022ZM11 7a2 2 0 1 0 0-4 2 2 0 0 0 0 4Zm3-2a3 3 0 1 1-6 0 3 3 0 0 1 6 0ZM6.936 9.28a5.88 5.88 0 0 0-1.23-.247A7.35 7.35 0 0 0 5 9c-4 0-5 3-5 4 0 .667.333 1 1 1h4.216A2.238 2.238 0 0 1 5 13c0-1.01.377-2.042 1.09-2.904.243-.294.526-.569.846-.816ZM4.92 10A5.493 5.493 0 0 0 4 13H1c0-.26.164-1.03.76-1.724.545-.636 1.492-1.256 3.16-1.275ZM1.5 5.5a3 3 0 1 1 6 0 3 3 0 0 1-6 0Zm3-2a2 2 0 1 0 0 4 2 2 0 0 0 0-4Z"/>
          </svg>

          <div className="grow ml-5">
            <h3 className="group-hover:text-blue-600 font-semibold text-gray-800 dark:group-hover:text-gray-400 dark:text-gray-200">
              <span className="font-bold">5</span> Groups
            </h3>
            <p className="text-sm text-gray-500">
             All the Groups you are, and have created
            </p>
          </div>
        </div>
      </div>
    </a>

    <a className="group flex flex-col bg-white border shadow-sm rounded-xl hover:shadow-md transition dark:bg-slate-900 dark:border-gray-800" href="#">
      <div className="p-4 md:p-5">
        <div className="flex">
          <svg className="mt-1 shrink-0 w-5 h-5 text-gray-800 dark:text-gray-200" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
            <path d="M5.5 2A3.5 3.5 0 0 0 2 5.5v5A3.5 3.5 0 0 0 5.5 14h5a3.5 3.5 0 0 0 3.5-3.5V8a.5.5 0 0 1 1 0v2.5a4.5 4.5 0 0 1-4.5 4.5h-5A4.5 4.5 0 0 1 1 10.5v-5A4.5 4.5 0 0 1 5.5 1H8a.5.5 0 0 1 0 1H5.5z"/>
            <path d="M16 3a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
          </svg>

          <div className="grow ml-5">
            <h3 className="group-hover:text-blue-600 font-semibold text-gray-800 dark:group-hover:text-gray-400 dark:text-gray-200">
            <span className="font-bold">10</span> Contributions
            </h3>
            <p className="text-sm text-gray-500">
             All your contributions so far
            </p>
          </div>
        </div>
      </div>
    </a>

    <a className="group flex flex-col bg-white border shadow-sm rounded-xl hover:shadow-md transition dark:bg-slate-900 dark:border-gray-800" href="#">
      <div className="p-4 md:p-5">
        <div className="flex">
        <svg className="mt-1 shrink-0 w-5 h-5 text-gray-800 dark:text-gray-200" xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16">
            <path d="M5.5 2A3.5 3.5 0 0 0 2 5.5v5A3.5 3.5 0 0 0 5.5 14h5a3.5 3.5 0 0 0 3.5-3.5V8a.5.5 0 0 1 1 0v2.5a4.5 4.5 0 0 1-4.5 4.5h-5A4.5 4.5 0 0 1 1 10.5v-5A4.5 4.5 0 0 1 5.5 1H8a.5.5 0 0 1 0 1H5.5z"/>
            <path d="M16 3a3 3 0 1 1-6 0 3 3 0 0 1 6 0z"/>
          </svg>

          <div className="grow ml-5">
            <h3 className="group-hover:text-blue-600 font-semibold text-gray-800 dark:group-hover:text-gray-400 dark:text-gray-200">
            <span className="font-bold">5</span> Rounds Completed
            </h3>
            <p className="text-sm text-gray-500">
              All the rounds completed by you and your group members 
            </p>
          </div>
        </div>
      </div>
    </a>

  </div>

</div>

        </>
    )
}