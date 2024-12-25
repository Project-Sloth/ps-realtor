<script lang="ts">
  import { ReceiveNUI } from '../utils/ReceiveNUI';
  import { SendNUI } from '../utils/SendNUI';
  import { onMount } from 'svelte';
  import { PROPERTIES, visibility } from '../store/stores';
  import BackdropFix from './BackdropFix.svelte';


let isVisible: boolean;

visibility.subscribe((visible: boolean) => {
  isVisible = visible;
});

ReceiveNUI<boolean>('setVisible', (visible: boolean) => {
  visibility.set(visible);
});

onMount(() => {
  const keyHandler = (e: KeyboardEvent) => {
    if (isVisible && ['Escape'].includes(e.code)) {
      SendNUI('hideUI');
      visibility.set(false);
    }
  };

  window.addEventListener('keydown', keyHandler);

  return () => window.removeEventListener('keydown', keyHandler);
});
</script>

{#if isVisible}
<main>
    <slot />
</main>
<!-- <BackdropFix /> -->
{/if}

<style>
  main {
    display: grid;
    place-items: center;
    height: 100vh;
  }
</style>

