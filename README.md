# LangChain in a Box
Hi there, [Alexis](https://alexisrondeau.me) here! I [make](https://jamgpt.app) [things](https://unblah.me/) [that](https://getpudding.app/) [do](https://getstreamline.app/) [things](https://alexisrondeau.me/algorand-ballet/). I am not a LangChain expert (yet) but I am starting to understand the power it provides.

This project is a 'batteries-included' macOS UI for LangChain. It ships with a self-contained, embedded, Apple-notarisable Python 3.11 and LangChain libraries. It also includes documentation on how to update langchain dependencies over time.

Why? Access to LangChain should be easy for those who want to change the world.

I saw my girlfriend fully embrace GPT-4 via [an app](https://jamgpt.app) I built for her. Even though it's "just a UI to GPT-4", it comes batteries-included. This allowed her to fully focus only on her projects and not the technology.

The hard, and tedious, part - like installing brew, getting the right Python version, creating the right venv, updating langchain, choosing and learning an IDE - should not a barrier to entry for her. 

## Development Notes
To build with XCode, please create APIConfig.xcconfig under $ROOT/EmbeddedPythonSpike/Backend with this content

```bash
$ cd $PROJECT_ROOT
$ touch ./EmbeddedPythonSpike/Backend/APIConfig.xcconfig
$ echo "OPENAI_API_KEY = your-api-key" > ./EmbeddedPythonSpike/Backend/APIConfig.xcconfig
```

### How to update LangChain and its dependencies

See [/python-langchain/README.md](./python-langchain/README.md) for details (Not shown in XCode, use Terminal)

## UI Evolution
![v1.1](v1.1.png)
![First Success](first-success.png)

## Notarizing
![Notarized with Developer ID](organizer-with-notarized-app-bundle.png)
![Upload and Sign](langchain.zip-content-apple-upload.png)

- Based on [my template for embedding Python in a signed macOS app](https://github.com/akaalias/EmbeddedPythonAppTemplate)
