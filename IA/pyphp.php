<?php
    $pythonScript = "my_script.py";
    $argument = "PHP User"; // Optional argument to pass to Python

    // Construct the command
    $command = escapeshellcmd("python " . $pythonScript . " " . $argument);

    // Execute the command and capture the output
    $output = shell_exec($command);

    // Display the output from the Python script
    echo "<h1>Output from Python:</h1>";
    echo "<pre>" . $output . "</pre>";
    ?>