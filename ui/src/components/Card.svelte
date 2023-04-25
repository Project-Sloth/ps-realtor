<script>
    let isCardClicked = false;
  
    function toggleCardClick() {
      isCardClicked = !isCardClicked;
    }

    
  </script>
  
  <div class="m-5 max-w-sm h-[20rem] bg-[color:var(--color-secondary)] border border-[color:var(--color-tertiary)] rounded-lg shadow">
    <a href="#" on:click={toggleCardClick}>
      <img class="rounded-t-lg" src="https://i.imgur.com/lSXDuXp.jpg" alt="" />
    </a>
    <div class="p-3">
      <a href="#">
        <h5 class="text-xl font-bold tracking-tight text-white">Available Properties</h5>
      </a>
      <span class="bg-[color:var(--color-tertiary)] text-blue-300 text-xs font-bold mr-2 px-3 py-1 rounded">Tier: 5</span>
      <span class="bg-[color:var(--color-tertiary)] text-blue-300 text-xs font-bold mr-2 px-3 py-1 rounded">Price: $200,000</span>
    </div>
  
    {#if isCardClicked}
      <div
        class="fixed top-0 left-0 right-0 bottom-0 flex items-center justify-center bg-opacity-50 z-50"
        on:click={toggleCardClick}
      >
        <div class="w-[40rem] h-[30rem] bg-[color:var(--color-secondary)] border border-[color:var(--color-tertiary)] rounded-lg shadow-lg">
            <div id="indicators-carousel" class="relative w-full" data-carousel="static">
                <!-- Carousel wrapper -->
                <div class="relative h-[18rem] overflow-hidden rounded-lg">
                    <img src="https://i.imgur.com/lSXDuXp.jpg" class="absolute block w-full h-[30rem] -translate-x-1/2 -translate-y-1/2 top-1/2 left-1/2" alt="">
                </div>
                <!-- Slider controls -->
                <button type="button" class="absolute top-0 left-0 z-30 flex items-center justify-center h-full px-4 cursor-pointer group focus:outline-none" data-carousel-prev>
                    <span class="inline-flex items-center justify-center w-8 h-8 rounded-full bg-[color:var(--color-tertiary)] group-hover:bg-[color:var(--color-accent)] ">
                        <svg aria-hidden="true" class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
                    </span>
                </button>
                <button type="button" class="absolute top-0 right-0 z-30 flex items-center justify-center h-full px-4 cursor-pointer group focus:outline-none" data-carousel-next>
                    <span class="inline-flex items-center justify-center w-8 h-8 rounded-full bg-[color:var(--color-tertiary)] group-hover:bg-[color:var(--color-accent)] ">
                        <svg aria-hidden="true" class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
                    </span>
                </button>
            </div>
            
            
          <div class="p-3">
            <a href="#">
              <h5 class="text-xl font-bold tracking-tight text-white">Available Properties</h5>
            </a>
            <span class="bg-[color:var(--color-tertiary)] text-blue-300 text-xs font-bold mr-2 px-3 py-1 rounded">Tier: 5</span>
            <span class="bg-[color:var(--color-tertiary)] text-blue-300 text-xs font-bold mr-2 px-3 py-1 rounded">Price: $200,000</span>
          </div>
        </div>
      </div>
    {/if}
  </div>
  