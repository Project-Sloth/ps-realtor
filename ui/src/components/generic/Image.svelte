<script lang="ts">
    export let src: string;
    export let alt: string;
    export let fallback: string;

    function handleError() {
        src = fallback;
    }
</script>

<img {src} {alt} on:error={handleError}>

<style>
    img {
        min-width: 100%;
        text-align: center;
    }
</style>