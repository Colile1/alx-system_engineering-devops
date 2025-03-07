# Postmortem: The Day the Sky Wasn't the Limit

## Issue Summary

### Duration:
The outage began at **14:30 UTC, March 6, 2025** and was resolved by **14:45 UTC, March 6, 2025**.

### Impact:
Our primary Nginx web server was under significant duress during high-load testing with ApacheBench. Out of **2000 simulated HTTP requests** (with 100 concurrent requests), **943 requests failed**—roughly **47% of all requests**—resulting in severe slowdowns. End users experienced intermittent service unavailability and delayed page loads. Preliminary estimates suggest around **30% of our user base** encountered service degradation.

### Root Cause:
The failure was ultimately traced to **misconfigured file descriptor limits** at both the operating system and Nginx levels. With the default settings in place, Nginx couldn’t open enough files to manage the high concurrency, causing failed requests.

---

## Timeline

- **14:30**: The issue was detected during routine load testing using ApacheBench, as monitoring systems alerted to an abnormal spike in failed requests.
- **14:31**: Engineers observed error logs citing "Too many open files" alongside numerous non-2xx HTTP responses.
- **14:33**: Initial investigations focused on a potential Nginx bug, though subsequent log analysis suggested resource limit issues.
- **14:35**: A misleading investigative path led the team to briefly consider network congestion as a cause; however, diagnostics quickly ruled this out.
- **14:37**: The incident was escalated to the infrastructure team. Detailed analysis confirmed that both OS and Nginx file descriptor limits were set far too low.
- **14:40**: Corrective action was taken immediately by applying a Puppet configuration (`0-the_sky_is_the_limit_not.pp`) to raise these limits.
- **14:43**: Re-running ApacheBench tests confirmed that failed requests dropped to zero, indicating that the issue was resolved.
- **14:45**: The incident was formally closed, and a post-incident review meeting was scheduled.

---

## Root Cause and Resolution

The underlying issue was a classic case of system resource misconfiguration. The OS default file descriptor limit did not support the concurrent connection load simulated during testing. Additionally, the Nginx configuration did not override these defaults to accommodate higher demands. 

The resolution involved updating the Puppet configuration to increase the file descriptor limits both on the OS and within Nginx. This ensured that Nginx could handle a greater number of simultaneous open files, thereby preventing the “Too many open files” error. The fix was validated by re-running load tests and confirming that all requests were successfully handled.

---

## Corrective and Preventative Measures

### Immediate Actions:
1. Update and enforce file descriptor limits across all servers using Puppet.
2. Patch the Nginx configuration to align with the new OS resource limits.

### Preventative Tasks:
1. **Enhanced Monitoring**: Implement monitoring for critical system resources, including file descriptor usage, to catch early warning signs.
2. **Regular Load Testing**: Integrate comprehensive load tests into the CI/CD pipeline to proactively identify and resolve scaling issues.
3. **Configuration Management**: Document and automate configuration updates to ensure consistency and to avoid manual errors.
4. **Infrastructure Review**: Schedule periodic reviews with the infrastructure team to re-evaluate resource limits, especially in anticipation of traffic spikes.

---

This incident serves as a reminder of the importance of proactive system configuration and monitoring to ensure scalability and reliability under high-load conditions.