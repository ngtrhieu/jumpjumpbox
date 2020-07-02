using System.Collections;
using NUnit.Framework;
using UnityEngine;
using UnityEngine.TestTools;

public class SampleUnitTest {

    [SetUp]
    public void SetUp () {
        // Setup code run here
    }

    [TearDown]
    public void TearDown () {
        // TearDown code run here
    }

    // A normal unit test case
    [Test]
    public void PlayModeTestsSimplePasses () {
        // Use the Assert class to test conditions.
        Assert.True (true);
    }

}