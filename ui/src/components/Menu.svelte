<script>
    import { slide } from 'svelte/transition';
	import Card from './Card.svelte'
	import CreateHouse from './CreateHouse.svelte'
    
    let activePage = 'home';

    function setActivePage(page) {
        activePage = page;
    }

</script>

<div class="flex justify-center items-center w-screen h-screen" transition:slide="{{duration: 300}}">
    <div class="w-[80rem] h-[50rem] bg-[color:var(--color-primary)]">
        <div class="w-[80rem] h-[45rem]">
            {#if activePage === 'create'}
                <CreateHouse />
            {:else}
            <div class="grid grid-cols-3 h-full overflow-auto">
                <Card/>
                <Card />
                <Card />
                <Card />
                <Card />
                <Card />
                <Card />
                <Card />
                <Card />
                <Card />
                <Card />
            </div>
            {/if}
        </div>
        <!-- Navbar -->
        <div class="w-full h-[5.2rem] bg-[color:var(--color-secondary)]">
            <div class="grid h-full max-w-lg grid-cols-2 mx-auto font-medium">
                <button type="button" on:click={() => setActivePage('home')} class="inline-flex flex-col items-center justify-center px-5 hover:bg-[color:var(--color-accent)] group">
                        <i class="fa-solid fa-house w-7 h-8 text-gray-200"></i>
                    <span class="text-sm text-gray-300 font-bold">Home</span>
                </button>
                <button type="button" on:click={() => setActivePage('create')} class="inline-flex flex-col items-center justify-center px-5 hover:bg-[color:var(--color-accent)] group">
                    <i class="fa-solid fa-plus w-7 h-8 text-gray-200"></i>
                    <span class="text-sm text-gray-300 font-bold">Create New</span>
                </button>
            </div>
        </div>
        
    </div>
</div>

<style>
    ::-webkit-scrollbar {
        width: 0.5rem;
    }

    ::-webkit-scrollbar-thumb {
        background-color: var(--color-accent);
    }
</style>
