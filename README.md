# Concurrent Data Processing Pipeline with Prioritization and Error Handling

This repository contains an advanced **concurrent data processing pipeline** built for iOS applications. The pipeline processes items through three distinct stages—**Download**, **Transform**, and **Save**—while managing concurrency, task dependencies, and prioritization.

## Features

- **Pipeline Stages**  
  Three-stage processing flow:  
  - **Download → Transform → Save**

- **Concurrency Control**  
  Manages task execution limits with:  
  - Up to **5 concurrent downloads**
  - **2 concurrent transformations**
  - **1 save operation** at a time to avoid disk contention

- **Task Prioritization**  
  Items are processed based on priority levels (**high, medium, low**) to ensure critical tasks are handled first.

- **Error Handling**  
  A robust retry mechanism with up to **2 retries** for failed tasks.

- **Cancellation Support**  
  Allows for cancellation of tasks at any stage, ensuring smooth removal from the pipeline if needed.

## Installation

Clone the repository:

```bash
git clone https://github.com/yourusername/repo-name.git
cd repo-name
```

Open the project in Xcode and build.

## Usage

1. Add your items to the pipeline.
2. Set the priority levels for each item.
3. Run the pipeline and observe the tasks being processed through the three stages.

## Contributing

Feel free to submit pull requests or report issues. All contributions are welcome!

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.

---
