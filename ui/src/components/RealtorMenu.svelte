<script lang="ts">
	import type { ITab } from '@typings/type'
	import { REALTOR_GRADE, TEMP_HIDE, CONFIG } from '@store/stores'
	import PropertyBase from './properties/PropertyBase.svelte'
	import ApartmentsBase from './apartments/ApartmentsBase.svelte'
	import ListPropertiesBase from './list-properties/ListPropertiesBase.svelte'
	import { SendNUI } from '@utils/SendNUI'

	// basic available tabs
	let availableNavTabs: ITab[] = [
		{
			name: 'Properties',
			icon: 'fas fa-home',
			component: PropertyBase,
		},
	];

	// available tabs based on properties/config values of user
	REALTOR_GRADE.subscribe((value) => {
		if (value >= $CONFIG.setApartments) {
			availableNavTabs.push({
				name: 'Apartments',
				icon: 'fas fa-building',
				component: ApartmentsBase,
			});
		}

		if (value >= $CONFIG.listNewProperty) {
			availableNavTabs.push({
				name: 'List New Property',
				icon: 'fas fa-plus-circle',
				component: ListPropertiesBase,
			});
		}
	});

	let selectedTab: ITab = availableNavTabs[0]

	function selectLeftTab(tab) {
		selectedTab = tab;
		if(tab.name.toLocaleLowerCase() === 'logout') {
			SendNUI("hideUI", {})
		}
	}

	let footerNavs: ITab[] = [
		{
			name: 'Help Center',
			icon: 'fas fa-life-ring',
			component: '',
		},
		{
			name: 'Logout',
			icon: 'fas fa-arrow-right-from-bracket',
			component: '',
		}
	];
</script>

<div
	class="w-[60%] h-[90%] bg-[color:var(--color-primary)] absolute -translate-x-1/2 left-1/2 top-1/2 -translate-y-1/2 realtor-menu-base"
	style="opacity: {$TEMP_HIDE ? "0" : "1"};"
>
	<div class="left-column">
		<div class="tab-wrapper">
			{#each availableNavTabs as tab}
				<div class="each-tab {selectedTab.name === tab.name ? 'each-tab-selected' : ''}" on:click={() => selectLeftTab(tab)}>
					<i class={tab.icon} />
					<p>{tab.name}</p>
				</div>
			{/each}
		</div>

		<div class="footer">
			<div class="tab-wrapper">
				{#each footerNavs as tab}
					<div class="each-tab {selectedTab.name === tab.name ? 'each-tab-selected' : ''}" on:click={() => selectLeftTab(tab)}>
						<i class={tab.icon} />
						<p>{tab.name}</p>
					</div>
				{/each}

				<div class="discord-wrapper">
					<div class="discord-emoji">
						<img src="images/discord-emoji.png" alt="Discord Emoji" />
					</div>

					<div class="discord-text">
						<p class="bold-text">More PS Stuff?</p>
						<p class="small-text">
							Visit Project Sloth’s official Discord community for all our other releases.
						</p>
					</div>

					<button class="visit-discord-btn">
						Visit Discord
					</button>
				</div>
			</div>
		</div>
	</div>

	<div class="right-column">
		<svelte:component this={selectedTab.component} />
	</div>

		<!-- <div class="w-full h-full overflow-hidden">
		<svelte:component this={selectedTab.component} />
	</div>
	<Tabs bind:selectedTab {availableNavTabs} /> -->
</div>
