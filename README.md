# TweetSplit
An iOS app that splits out of bound tweet into multiple within bounds tweets and posts on behalf of the user.

## System Requirement
- iOS 11.0 or greater
- Swift 4.2
- XCode 10.0

## Tweet Splitter Implementation

Tweet splitter is an extension on String class and it works in two steps

- **Step 1:** A custom tokenizer. Custom tokenizer helps to detect unsplittable tweets early and thus throws an error. Secondly it provides total length of normalized string (without extra spaces) which helps in more accurate estimation of the parts. Time complexity of tokenizer is `O(n)` and space complexity is also `O(n)`

- **Step 2:** Tweet builder. Using tokens and estimated parts count it builds sub-tweets. At the end if generated parts are more than estimated parts then it goes through another iteration. It is able to generate correct subtweets in maximum two passes. Tweet builder uses recursion and time complexity is `O(n)`

**TweetSplitTests** is a comprehensive unit test class to verify that tweet splitter works for all different corner cases.

## TweetSplit App

App uses chat like interface to compose tweets and display message history.
