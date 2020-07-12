// Depend on which GIT_BRANCH, returns the appropriate addressable profile back to console
if (!process.env.GIT_BRANCH) {
  console.error("GIT_BRANCH is not set");
  process.exit(1);
}

switch (process.env.GIT_BRANCH.toLowerCase()) {
  case "master":
    console.log("master"); // Print out addressable profile
    break;

  default:
    console.log("Default");
    break;
}
