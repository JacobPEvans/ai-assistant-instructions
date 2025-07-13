# Concept: Adversarial Testing of AI Plans

## The "Second Opinion" Principle

A single AI model, like a single human, can have blind spots. To create a more robust and resilient plan, it's crucial to get a "second opinion" from a
different model. This practice of "adversarial testing" helps identify weaknesses, uncover hidden risks, and improve the overall quality of the plan before
implementation begins.

## The Process

1. **Generate the Initial Plan**: Use your primary AI assistant to generate a detailed implementation plan based on the project requirements (as outlined in
   `workflows/2-plan-and-document.md`).

2. **Seek a Critique from a Different Model**: Paste the generated plan into a different AI model (e.g., if you used Claude for planning, use Gemini or
   another model for the critique).

3. **Use a Critical Prompt**: Frame the request from the perspective of a skeptical senior engineer.

    > **Prompt**: "Critique this AI-generated plan. As a senior engineer, what problems or risks do you see?"

4. **Integrate Feedback**: Analyze the feedback from the second AI. If it highlights valid issues, refine the original plan before locking it in and
   proceeding to the implementation phase.

## Why It Works

- **Reduces Model Bias**: Different models have different training data and architectures, leading them to identify different potential issues.
- **Improves Robustness**: It forces a more thorough consideration of edge cases and potential failure points.
- **Catches "Lazy" Answers**: It prevents the primary AI from taking simple shortcuts that might lead to problems later.
