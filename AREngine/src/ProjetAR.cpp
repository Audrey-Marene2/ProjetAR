#include <SDL3/SDL.h>
#include <glad/gl.h>
#include <imgui.h>
#include <imgui_impl_sdl.h>
#include <imgui_impl_opengl3.h>
#include <iostream>

// Prototypes de fonctions
bool InitSDL(SDL_Window*& window, SDL_GLContext& glContext);
void Cleanup(SDL_Window* window, SDL_GLContext glContext);
void MainLoop(SDL_Window* window, SDL_GLContext glContext);

int main(int argc, char* argv[])
{
    SDL_Window* window = nullptr;
    SDL_GLContext glContext = nullptr;

    if (!InitSDL(window, glContext)) {
        std::cerr << "Failed to initialize SDL and OpenGL" << std::endl;
        return -1;
    }

    MainLoop(window, glContext);

    Cleanup(window, glContext);
    return 0;
}

bool InitSDL(SDL_Window*& window, SDL_GLContext& glContext)
{
    // Initialisation de SDL
    if (SDL_Init(SDL_INIT_VIDEO) != 0) {
        std::cerr << "Erreur SDL_Init: " << SDL_GetError() << std::endl;
        return false;
    }

    // Création de la fenêtre SDL avec support OpenGL
    window = SDL_CreateWindow("ProjetAR - SDL & OpenGL", 800, 600, SDL_WINDOW_OPENGL | SDL_WINDOW_RESIZABLE);
    if (!window) {
        std::cerr << "Erreur SDL_CreateWindow: " << SDL_GetError() << std::endl;
        return false;
    }

    // Création du contexte OpenGL
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 4);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_MINOR_VERSION, 5);
    SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_CORE);

    glContext = SDL_GL_CreateContext(window);
    if (!glContext) {
        std::cerr << "Erreur SDL_GL_CreateContext: " << SDL_GetError() << std::endl;
        return false;
    }

    SDL_GL_SetSwapInterval(1); // VSync activé

    // Chargement des extensions OpenGL avec Glad
    if (!gladLoadGL((GLADloadfunc)SDL_GL_GetProcAddress)) {
        std::cerr << "Failed to initialize Glad" << std::endl;
        return false;
    }

    // ImGui context
    IMGUI_CHECKVERSION();
    ImGui::CreateContext();
    ImGuiIO& io = ImGui::GetIO(); (void)io;
    ImGui::StyleColorsDark();

    // Setup Platform/Renderer bindings
    ImGui_ImplSDL2_InitForOpenGL(window, glContext);
    ImGui_ImplOpenGL3_Init("#version 450");

    return true;
}

void MainLoop(SDL_Window* window, SDL_GLContext glContext)
{
    bool running = true;
    SDL_Event event;

    while (running) {
        // Gestion des événements SDL
        while (SDL_PollEvent(&event)) {
            ImGui_ImplSDL2_ProcessEvent(&event);
            if (event.type == SDL_QUIT) {
                running = false;
            }
        }

        // Commence la nouvelle frame ImGui
        ImGui_ImplOpenGL3_NewFrame();
        ImGui_ImplSDL2_NewFrame(window);
        ImGui::NewFrame();

        // Interface utilisateur avec ImGui
        ImGui::Begin("Hello, world!");
        ImGui::Text("This is a simple SDL + OpenGL + ImGui demo.");
        ImGui::End();

        // Rendu OpenGL
        glClearColor(0.2f, 0.3f, 0.3f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);

        // Rendu de l'interface ImGui
        ImGui::Render();
        ImGui_ImplOpenGL3_RenderDrawData(ImGui::GetDrawData());

        // Présentation du buffer OpenGL
        SDL_GL_SwapWindow(window);
    }
}

void Cleanup(SDL_Window* window, SDL_GLContext glContext)
{
    // Cleanup ImGui
    ImGui_ImplOpenGL3_Shutdown();
    ImGui_ImplSDL2_Shutdown();
    ImGui::DestroyContext();

    // Cleanup SDL et OpenGL
    SDL_GL_DeleteContext(glContext);
    SDL_DestroyWindow(window);
    SDL_Quit();
}
