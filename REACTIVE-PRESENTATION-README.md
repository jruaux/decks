# Reactive Programming Lightning Talk - README

## What I've Created

I've put together a 5-minute lightning talk presentation on reactive programming for your Field Engineering team meeting. The presentation uses your existing riotx and redis-cache-java projects as real-world examples.

## Files Created

1. **`docs/reactive-programming.adoc`** - The main presentation (17 slides)
2. **`docs/reactive-programming-notes.md`** - Detailed speaker notes with timing, talking points, and Q&A prep
3. **`build/reactive-programming.html`** - The compiled HTML presentation (already built)

## Presentation Structure

### Theme Alignment
- **Primary:** Technical Depth (deep dive into reactive paradigm)
- **Secondary:** Customer Orientation (better performance = better customer experience)
- **Tertiary:** Operational Excellence (better resource utilization)

### Key Narrative Arc
1. **Problem:** RIOT uses batch processing (Spring Batch) which has idle time and fixed chunk sizes
2. **Solution:** Reactive streams provide continuous flow with backpressure
3. **Evidence:** redis-cache-java already uses reactive successfully
4. **Plan:** Incremental migration for RIOT using Lettuce's reactive API
5. **Impact:** Better latency, throughput, and resource utilization for customers

## How to Use

### Building the Presentation

```bash
# From the decks directory
/opt/homebrew/lib/ruby/gems/3.4.0/bin/asciidoctor-revealjs \
  -a revealjsdir=https://cdn.jsdelivr.net/npm/reveal.js@4.5.0 \
  -a revealjs_theme=black \
  -a revealjs_transition=slide \
  -a revealjs_slideNumber=true \
  -a revealjs_history=true \
  -a customcss=css/headings.css \
  -a source-highlighter=highlight.js \
  -o build/reactive-programming.html \
  docs/reactive-programming.adoc
```

Or just open the already-built file:
```bash
open build/reactive-programming.html
```

### Presenting

1. Open `build/reactive-programming.html` in your browser
2. Use arrow keys or space to advance slides
3. Press 'S' for speaker notes (if you add them to the .adoc file)
4. Press 'F' for fullscreen
5. Press '?' for help

### Timing (5 minutes total)

- **0:00-0:30** - Introduction & Challenge
- **0:30-1:30** - Problem Definition (Batch Processing)
- **1:30-2:30** - Solution (Reactive Streams)
- **2:30-3:30** - Real Example & Comparison
- **3:30-4:00** - Implementation Plan
- **4:00-4:30** - Lessons & Takeaways
- **4:30-5:00** - Questions

## Key Concepts Covered

### 1. Batch Processing (Current State)
- Spring Batch chunk-oriented processing
- Read → Process → Write in chunks
- Idle time between chunks
- Fixed chunk sizes

### 2. Reactive Streams (Future State)
- Continuous data flow
- Process items as they arrive
- Backpressure for flow control
- Better resource utilization

### 3. Real Examples
- **redis-cache-java:** Shows reactive working with Spring Cache and Mono
- **RIOT migration:** Shows the path from ItemReader/ItemWriter to Flux/reactive

### 4. Benefits
- **Latency:** First item processed immediately
- **Throughput:** No idle time between chunks
- **Memory:** Process items as they flow
- **Scalability:** Better resource utilization
- **Resilience:** Backpressure prevents cascading failures

## Diagrams Included

I've created two Mermaid diagrams to help visualize the concepts:

1. **Batch vs Reactive Flow:** Shows the difference in processing patterns
2. **Reactive Streams Sequence:** Shows how backpressure works with request/response

These are rendered separately but can be referenced during the talk.

## Customization Tips

### If You Want to Add More Technical Depth
- Add a slide on Project Reactor operators (map, flatMap, filter)
- Include performance benchmarks if you have them
- Show more code from the actual RIOT migration

### If You Want to Emphasize Customer Impact
- Add customer success stories (if any)
- Include specific use cases (e.g., large-scale migrations)
- Show before/after metrics

### If You Want to Add Operational Excellence
- Include monitoring/observability aspects
- Show how reactive helps with resource management
- Discuss deployment strategies

## Practice Suggestions

1. **Run through once at normal pace** - Should take about 4:30
2. **Practice the backpressure explanation** - This is the key concept
3. **Memorize the redis-cache-java code example** - You'll want to explain it smoothly
4. **Prepare for questions** - See the notes file for common Q&A
5. **Test on the actual presentation setup** - Make sure fonts/colors work

## Potential Enhancements

If you have more time before the presentation:

1. **Add actual performance metrics** from RIOT benchmarks
2. **Create a live demo** showing reactive vs batch side-by-side
3. **Add more code examples** from the actual RIOT codebase
4. **Include customer quotes** if you have them
5. **Add speaker notes** directly in the .adoc file using `[NOTE.speaker]` blocks

## Resources for Deep Dive

If people want to learn more:

- **Project Reactor:** https://projectreactor.io/docs/core/release/reference/
- **Lettuce Reactive:** https://lettuce.io/core/release/reference/index.html#reactive-api
- **Spring WebFlux:** https://docs.spring.io/spring-framework/reference/web/webflux.html
- **Reactive Streams Spec:** https://www.reactive-streams.org/

## Presentation Style

The presentation follows your existing style:
- Black theme (consistent with your other presentations)
- Progressive disclosure (using `[%step]`)
- Code examples with syntax highlighting
- Speaker notes for key concepts
- Clean, minimal design

## Next Steps

1. **Review the presentation** - Open `build/reactive-programming.html`
2. **Read the speaker notes** - Review `docs/reactive-programming-notes.md`
3. **Practice timing** - Aim for 4:30 to leave buffer
4. **Customize if needed** - Edit `docs/reactive-programming.adoc`
5. **Rebuild if you make changes** - Use the build command above

## Questions?

The presentation is ready to go! The narrative flows from problem → solution → evidence → plan → impact, which should resonate well with your team.

Good luck with your lightning talk! 🚀

