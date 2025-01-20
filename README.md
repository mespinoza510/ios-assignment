# ios-assignment

### Summary: Include screen shots or a video of your app highlighting its features
  
#### Empty State / List of Recipes / Recipe Detail Screen / Open URL within App / Pagination feature
<img src="https://github.com/user-attachments/assets/1be307a1-1747-4e5a-98ce-f3b59e90968b" alt="Empty State" width="150" height="300">

<img src="https://github.com/user-attachments/assets/559b7916-7ee9-4237-af7e-2cd9f48240cd" alt="Recipes Screenshot" width="150" height="300">

<img src="https://github.com/user-attachments/assets/a25c955f-775c-4fbb-a7b4-55c46207e53b" alt="Recipes Detail Screen" width="150" height="300">

<img src="https://github.com/user-attachments/assets/5a399e9a-6907-40a4-962f-2d1e107f6003" alt="Open url in-app" width="150" height="300">

<img src="https://github.com/user-attachments/assets/f6c61fe8-1569-4e1a-a4a3-693bcdb4bd9a" alt="Open url in-app" width="150" height="300">


### Focus Areas: What specific areas of the project did you prioritize? Why did you choose to focus on these areas?
I prioritized several key areas throughout the project. First, I focused on ensuring I could decode the data efficiently using concurrency before moving on to the UI. Once the UI was set up to my satisfaction, I refactored it to conform to the MVVM architecture and simplified the views for better maintainability. I also dedicated time to adding accessibility features, including support for VoiceOver. After that, I implemented list refreshing and pagination as the final feature. Finally, I worked on unit testing, which was a relatively new area for me in iOS development, allowing me to strengthen my skills in that space

### Time Spent: Approximately how long did you spend working on this project? How did you allocate your time?
I began by reviewing the requirements and planning out the features I wanted to implement and the tasks I needed to complete. One area where I had limited knowledge was unit testing, so I knew it would take some time to dive deep into structuring tests and learning proper testing techniques. I broke down my tasks based on the project’s needs, starting with decoding the JSON data and ensuring proper error handling. Afterward, I focused on the UI and refactoring the code to separate the UI from the view model, making optimizations for cleanliness and readability. Overall, it took a few days to complete, and I was able to execute the project according to the tasks I had set out to accomplish.

### Trade-offs and Decisions: Did you make any significant trade-offs in your approach?
I initially considered targeting iOS 16, but later realized that one of the features I wanted to implement would be more time-consuming than necessary. Since it wasn’t essential for the project and I was just personally interested in it, I decided to move forward with iOS 17 instead.

### Weakest Part of the Project: What do you think is the weakest part of your project?
Initially, I struggled with setting up unit tests and understanding the best techniques for doing so. I did a deep dive into various forums and resources from experienced developers to learn more. After some effort, I believe I was able to accomplish the task, but I’d like to continue working on improving my skills in building iOS apps with a stronger focus on unit testing. In most of my previous iOS development experience, manual testers were typically responsible for testing, so this was a new area for me to explore.

### Additional Information: Is there anything else we should know? Feel free to share any insights or constraints you encountered.
Some of the challenges I encountered were related to refreshing the UI. For instance, I observed that there were 63 recipes, and given the amount of data, a refresh wasn’t necessary. However, if the backend had an API supporting pagination with customizable page sizes (similar to GitHub's API), I would have been able to implement that for better performance. I had planned to tackle this manually, but I ran into some issues that required troubleshooting. I also received warnings in the console that I felt needed attention, so I took time to refactor and address those concerns.

In addition, I explored the use of AsyncImage during my spare time to understand its caching behavior. I came across conflicting opinions regarding whether it caches images. Some sources claimed it does, while others suggested it does not, with the latter being somewhat outdated (circa 2021). Ultimately, I chose to proceed with the assumption that AsyncImage does cache images, especially for smaller apps like the one I built here. That said, many articles recommend using third-party dependencies for more robust caching solutions.

